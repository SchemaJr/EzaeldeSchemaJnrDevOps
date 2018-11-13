#region...Variables and Credentials for VM

#Login First to the Azure Portal

Add-AzureRmAccount

Write-Host "You will be creating 2 Virtual Machines inside a High Availability Set" -ForegroundColor DarkMagenta

# These are your Variables
$resourceGroup = "HAResourcegroup"
$location = "eastus"
$vmName = "MyHAVM"

# This step creates User credentials
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

#endregion
#region Resourcegroup and New Availability Set
# Now you will be creating a resource group

 New-AzureRmResourceGroup -Name $resourceGroup -Location $location

#You will be creating an Availability Set

New-AzureRmAvailabilitySet `
   -Location "$location" `
   -Name "HASet" `
   -ResourceGroupName "$resourceGroup" `
   -Sku aligned `
   -PlatformFaultDomainCount 2 `
   -PlatformUpdateDomainCount 2

   #endregion
#region New Vm and it's Variables

#New VM and variables

$vnetName = "HAVnet"
$SubnetName = "HASubnet"
$SecGroupName = "HANetworkSecurityGroup"
$AvailSetName = "HASet"

   for ($i=1; $i -le 2; $i++)
{
    New-AzureRmVm `
        -ResourceGroupName "$resourceGroup" `
        -Name "HAVM$i" `
        -Location "$resourceGroup" `
        -VirtualNetworkName "$vnetName" `
        -SubnetName "$SubnetName" `
        -SecurityGroupName "$SecGroupName" `
        -PublicIpAddressName "HAPublicIpAddress$i" `
        -AvailabilitySetName "$AvailSetName" `
        -Credential $cred
}

Write-host "Login to the Azure Portal and check your configuration" -ForegroundColor DarkMagenta

#endregion