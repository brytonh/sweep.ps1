###Ping sweep script in powershell###   
###Bryton Herdes###

#Write-Host Script can only handle one subnet at once at this time. Further Development is in progress.`n

#Prompt for user to enter starting IP and ending IP
$begin=Read-Host -Prompt "Starting IP"
$end=Read-Host -Prompt "Ending IP"


##########################################Starting IP tracking starts###########################################

#Get a string of the first octet for later use
[string]$octetOne=""

#Search for the first octet length, find and same as "j"
[int]$i=0
while ($begin[$i] -ne ".") {
    $octetOne+=$begin[$i]
    $i++;
}

#Get a string of the second octet for later use
[string]$octetTwo=""

#Bring i to next non "."
$i++

while($begin[$i] -ne ".") {
    $octetTwo+=$begin[$i]
    $i++
}

#Bring i to next non "."
$i++

#Create string to hold octet 3
[string]$octetThree=""

while($begin[$i] -ne ".") {
    #Write-Host $begin[$i]
    $octetThree += $begin[$i]
    $i++
}

#Move i to next non "."
$i++

#Create string to hold octet 4
[string]$octetFour=""

while($i -le 14) {
   # Write-Host $begin[$i]
    if($begin[$i] -ne ".") {
        $octetFour += $begin[$i]
        $i++
    }
    else {
        break
    }
}


#####################################Ending IP tracking starts###############################################

#Get a string of the first octet for later use
[string]$octetOneEnd=""

#Search for the first octet length, find and same as "j"
[int]$i=0
while ($end[$i] -ne ".") {
    $octetOneEnd+=$end[$i]
    $i++;
}

#Get a string of the second octet for later use
[string]$octetTwoEnd=""

#Bring i to next non "."
$i++

while($end[$i] -ne ".") {
    $octetTwoEnd+=$end[$i]
    $i++
}

#Bring i to next non "."
$i++

#Create string to hold octet 3
[string]$octetThreeEnd=""

while($end[$i] -ne ".") {
    $octetThreeEnd += $end[$i]
    $i++
}

#Move i to next non "."
$i++

#Create string to hold octet 4
[string]$octetFourEnd=""

while($i -le 14) {
   # Write-Host $begin[$i]
    if($end[$i] -ne ".") {
        $octetFourEnd += $end[$i]
        $i++
    }
    else {
        break
    }
}


Write-Host `nStarting ping sweep between IPs:
Write-Host -fore Cyan  $octetOne"."$octetTwo"."$octetThree"."$octetFour "and" $octetOneEnd"."$octetTwoEnd"."$octetThreeEnd"."$octetFourEnd

#####################################PING SWEEP CODE BEGINS#########################################

[int]$octetThreeInt = $octetThree
[int]$octetThreeEndInt = $octetThreeEnd
[int]$octetFourInt = $octetFour
[int]$octetFourEndInt = $octetFourEnd

New-Item C:/Users/"Bryton Herdes"/Desktop/success.txt -type file -force
New-Item C:/Users/"Bryton Herdes"/Desktop/failed.txt -type file -force
Write-Host `n

if($octetThreeEndInt -gt $octetThreeInt) {
 while($octetThreeEndInt -ge $octetThreeInt) {
    while($octetFourInt -le 254) {
        $IP="$octetOne.$octetTwo.$octetThreeInt.$octetFourInt"
        #Print to screen successful ping to IP's that have True output of testconnection. Could be altered 
        #to notify you of False outputs (unsuccessful pings)
        if((test-connection -quiet -count 1 -computername $IP) -eq $True) {
            Write-Host Successful ping to $IP
            Add-Content C:/Users/"$env:UserName"/Desktop/success.txt "$IP"
        }
        else {
            Write-Host Failed ping to $IP
            Add-Content C:/Users/"$env:UserName"/Desktop/failed.txt "$IP"
        }

        #Exit script if we have pinged our ending IP
        if($IP -eq $end) {
            exit
        }

        #incrememnt the begin variable to test next IP
        $octetFourInt++
    }
    if($octetFourInt -eq 255) {
        $octetThreeInt++
        $octetFourInt=1
    }

 }
}
else {
   while ($octetFourInt -le $octetFourEndInt) {

       $IP="$octetOne.$octetTwo.$octetThree.$octetFourInt"

    #Print to screen successful ping to IP's that have True output of testconnection. Could be altered 
    #to notify you of False outputs (unsuccessful pings)
    if((test-connection -quiet -count 1 -computername $IP) -eq $True) {
        Write-Host Successful ping to $IP
        Add-Content C:/Users/"$env:UserName"/Desktop/success.txt "$IP"
    }
    else {
        Write-Host Failed ping to $IP
        Add-Content C:/Users/"$env:UserName"/Desktop/failed.txt "$IP"
    }
  
    #increment the begin variable to test next IP
    $octetFourInt++
  }
}    
