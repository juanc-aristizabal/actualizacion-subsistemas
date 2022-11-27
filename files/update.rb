require 'fileutils'
require 'net/http'
require 'socket'
require 'digest'
require 'base64'
require 'openssl'


def get_data(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    data = response.body
end

def process_sharedparams(data)

   edit = ""
   arr = data.split("\n")
   found = data.include?("<username>")

     if found
         for element in arr
           if  element.include?("<username>")==false && element.include?("<password>")==false && element.include?("<oidPolicy>")==false
            edit += element + ("\n")
           end    
         end 
     else
         parameters = "        <username></username>\n        <password></password>\n        <oidPolicy></oidPolicy>\n"
         for element in arr
           if  element.include?("</approvedTSA>")==true
             edit += parameters
             edit += "</approvedTSA>"
           else
             edit += element + ("\n")
           end  
         end
     end
   
    return edit

end

def load_anchor(name_anchor)
        anchor = File.read '/var/lib/xroad/public/anchors/' + name_anchor
end 

def edit_anchor(anchor)

        ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address
        key_cert   = File.read '/var/lib/xroad/public/key/AND_certificate.crt'
        key_cert   = (((key_cert.gsub "\n","").sub "-----BEGIN CERTIFICATE-----","").sub "-----END CERTIFICATE-----","").strip
        dec64    = Base64.decode64(key_cert)
        hash512  = OpenSSL::Digest::SHA512.digest(dec64)
        key_hash = Base64.encode64(hash512)
        key_hash = key_hash.gsub "\n",""
        arr_anchor       = anchor.split("\n")
        instance         = ((arr_anchor[3].sub "<instanceIdentifier>","").sub "</instanceIdentifier>","").strip
        externalconf_url = arr_anchor[5]
        externalconf_url = ((externalconf_url.sub "<downloadURL>","").sub "</downloadURL>","").strip
        arr_anchor[5]    = "        <downloadURL>http://" + ip_address + "/externalconf_" + instance + "</downloadURL>"
        arr_anchor[6]    = "        <verificationCert>" + key_cert + "</verificationCert>"
        externalconf_data = get_data(externalconf_url)
        arr = externalconf_data.split("\n")
        shared_params_url    = externalconf_url.sub "/externalconf","" + (arr[13].sub "Content-location: ","")
        shared_params_folder = ((arr[13].sub "Content-location: ","").sub "/V2/","").sub "/shared-params.xml",""
        shared_params_data   = get_data(shared_params_url)
        shared_params_data   = process_sharedparams(shared_params_data)
        hash = OpenSSL::Digest::SHA512.digest(shared_params_data)
        shared_params_hash = Base64.encode64(hash)
        shared_params_hash = shared_params_hash.gsub "\n",""
        arr[6]  = "Expire-date: 2022-12-18T01:20:01Z";
        arr[13] = "Content-location: /V2_/" + shared_params_folder + "/shared-params.xml"
        arr[16] = shared_params_hash
        arr[22] = "Verification-certificate-hash: " + key_hash + '; hash-algorithm-id="http://www.w3.org/2001/04/xmlenc#sha512"';
        signedData = ""
        for i in 5..17 do
          if i<17
             signedData += arr[i] + ("\n")
          else
             signedData += arr[i]
          end
        end
        key_private = OpenSSL::PKey.read File.read '/var/lib/xroad/public/key/AND_private.key'
        digest      = OpenSSL::Digest::SHA512.new
        signature   = key_private.sign digest, signedData
        signature64 = Base64.encode64(signature)
        arr[24] = signature64;
        if key_private.verify digest, signature, signedData
          ok = 'Valid'
        else
          ok 'Invalid'
        end
        externalconf_data = "";
        for element in arr
         externalconf_data += element + ("\n")
        end
        File.open("/var/lib/xroad/public/externalconf_"+instance,"w"){
                                                                     |f| f.write externalconf_data
                                                                      f.chmod(0755)
                                                                    }       
        path_v2 = "/var/lib/xroad/public/V2_/"
        FileUtils.mkdir_p path_v2
        FileUtils.chmod(0755, path_v2)
 
        path_v2_serial = path_v2 + "/" + shared_params_folder
        FileUtils.mkdir_p path_v2_serial
        FileUtils.chmod(0755, path_v2_serial)


        shared_params_pathname = path_v2_serial + '/shared-params.xml'
        File.open(shared_params_pathname, "w"){
                                               |f| f.write shared_params_data
                                               f.chmod(0755)
                                             }

        new_anchor_data = arr_anchor.join("\n")

end



  count = Dir.glob("/var/lib/xroad/public/V2_/*").length
   if count >= 6 
    	FileUtils.rm_rf("/var/lib/xroad/public/V2_")
   else 
      puts count
   end


  list = Dir.glob("/var/lib/xroad/public/anchors/*.xml")
   for i in list do
    edit_anchor(File.read i) 
   end        
  puts list.length()


