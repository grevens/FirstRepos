Function Get-ADTrustInfo

{

       Param ($TrustInfo)

 

       $propertyhash = @{

        TrustName = $NULL

        TrustCreated = $NULL

        TrustModified = $NULL

              TrustType = $NULL

              TrustAttribute = $NULL

              TrustDirection = $NULL

       

       }

   

    $TrustName = $TrustInfo.Name

    $TrustCreated = $TrustInfo.Created

    $TrustModified = $TrustInfo.Modified

       $TrustDirectionNumber = $TrustInfo.TrustDirection

       $TrustTypeNumber = $TrustInfo.TrustType

       $TrustAttributesNumber = $TrustInfo.TrustAttributes

  

      

    $propertyhash['TrustName'] = "$TrustName"

    $propertyhash['TrustCreated'] = $TrustCreated

   $propertyhash['TrustModified'] = $TrustModified

 

 

       #http://msdn.microsoft.com/en-us/library/cc234293.aspx

       Switch ($TrustTypeNumber)

       {

              1 { $propertyhash['TrustType'] = "Trust with a Windows domain not running Active Directory"; Break}

              2 { $propertyhash['TrustType'] = "Trust with a Windows domain running Active Directory"; Break}

              3 { $propertyhash['TrustType'] = "Trust with a non-Windows-compliant Kerberos distribution"; Break}

              4 { $propertyhash['TrustType'] = "Trust with a DCE realm (not used)"; Break}

              Default { $propertyhash['TrustType'] = "Invalid Trust Type of $($TrustTypeNumber)" ; Break}

       }

      

       $propertyhash['TrustAttribute'] = @()

       #$hextrustAttributesValue = '{0:X}' -f $trustAttributesNumber

       Switch ($trustAttributesNumber)

       {

              1 {$propertyhash['TrustAttribute'] += "Non-Transitive"}

              2 {$propertyhash['TrustAttribute'] += "Uplevel clients only"}

              4 {$propertyhash['TrustAttribute'] += "Quarantined Domain (External, SID Filtering)"}

              8 {$propertyhash['TrustAttribute'] += "Cross-Organizational Trust (Selective Authentication)"}

              16 {$propertyhash['TrustAttribute'] += "Interforest Trust"}

              32 {$propertyhash['TrustAttribute'] += "Intraforest Trust"}

              64 {$propertyhash['TrustAttribute'] += "MIT Trust using RC4 Encryption"}

        72 {$propertyhash['TrustAttribute'] += "Forest Trust + Inter-Forest Trust"}

              512 {$propertyhash['TrustAttribute'] += "Cross organization Trust no TGT delegation"}

       }

      

       Switch ($TrustDirectionNumber)

       {

              0 { $propertyhash['TrustDirection'] = "Disabled"; Break}

              1 { $propertyhash['TrustDirection'] = "Inbound"; Break}

              2 { $propertyhash['TrustDirection'] = "Outbound"; Break}

              3 { $propertyhash['TrustDirection'] = "Bidirectional"; Break}

              Default { $propertyhash['TrustDirection'] = $TrustDirectionNumber ; Break}

       }

    

      

       New-Object -Type PSObject -property $propertyhash

}

 

 

$ADDomainTrusts = $Null

$domain = (Get-WmiObject -class Win32_ComputerSystem).domain

$ADDomainTrusts = Get-ADObject -Filter {ObjectClass -eq "trustedDomain"} -Server $domain -Properties * -EA 0

 

 

If($? -and $Null -ne $ADDomainTrusts)

    {

                                 

           ForEach($Trust in $ADDomainTrusts)

                  {

                                        

      

                                         $TrustAttributes = Get-ADTrustInfo $Trust

                                         $TrustAttributes

                                        

                                  }

                           }

                           ElseIf(!$?)

                           {

                                  #error retrieving domain trusts

                                  Write-Warning "Error retrieving domain trusts for $($Domain)"

                                  #WriteHTMLLine 0 0 "Error retrieving domain trusts for $($Domain)" "" $Null 0 $False $True

                           }

                           Else

                           {

                                  #no domain trust data

                                  #WriteHTMLLine 0 0 "None"

                Write-Warning "Error retrieving domain trusts for $($Domain)"

                            }

 