###Ping sweep script in powershell###   
###Bryton Herdes###

#Prompt for user to enter starting IP and ending IP
$begin=Read-Host -Prompt "Starting IP"
$end=Read-Host -Prompt "Ending IP"


##########################################Starting IP tracking starts###########################################

#Get a string of the first octet for later use
[string]$octetOne=""

#Search for the first octet length, find and same as "j"
[int]$i=0

#Track octet 1 of start
while ($begin[$i] -ne ".") {
    $octetOne+=$begin[$i]
    $i++;
}

#Get a string of the second octet for later use
[string]$octetTwo=""

#Bring i to next non "."
$i++

#Track octet 2 of start
while($begin[$i] -ne ".") {
    $octetTwo+=$begin[$i]
    $i++
}

#Bring i to next non "."
$i++

#Create string to hold octet 3
[string]$octetThree=""

#Track octet 3 of start
while($begin[$i] -ne ".") {
    $octetThree += $begin[$i]
    $i++
}

#Move i to next non "."
$i++

#Create string to hold octet 4
[string]$octetFour=""

#Track octet 4 of start
while($i -le 14) {
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

#Track octet 1 of end
while ($end[$i] -ne ".") {
    $octetOneEnd+=$end[$i]
    $i++;
}

#Get a string of the second octet for later use
[string]$octetTwoEnd=""

#Bring i to next non "."
$i++

#Track octet 2 of end
while($end[$i] -ne ".") {
    $octetTwoEnd+=$end[$i]
    $i++
}

#Bring i to next non "."
$i++

#Create string to hold octet 3
[string]$octetThreeEnd=""

#Track octet 3 of end
while($end[$i] -ne ".") {
    $octetThreeEnd += $end[$i]
    $i++
}

#Move i to next non "."
$i++

#Create string to hold octet 4
[string]$octetFourEnd=""

#Track octet 4 of end
while($i -le 14) {
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

        #output
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

        #increment the octet 4 variable to test next IP
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

    #output
    if((test-connection -quiet -count 1 -computername $IP) -eq $True) {
        Write-Host Successful ping to $IP
        Add-Content C:/Users/"$env:UserName"/Desktop/success.txt "$IP"
    }
    else {
        Write-Host Failed ping to $IP
        Add-Content C:/Users/"$env:UserName"/Desktop/failed.txt "$IP"
    }
  
    #increment the octet 4 variable to test next IP
    $octetFourInt++
  }
}    