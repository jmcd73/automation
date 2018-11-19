$api_config = Import-LocalizedData -FileName 'api_config-XYZ-FileShares.psd1'





# $results = Get-ITGlueFlexibleAssets -filter_organization_id 564716 -filter_flexible_asset_type_id 12476
# $results.data.attributes.traits.'share-path'


function Check-Duplicate-FlexibleAsset {
	Param ( [string]$SharePath )
	
	Write-Host "Searching Org ID $($api_config.org_id) for SharePath $($SharePath)`n
on Flex Asset ID $($api_config.flexible_asset_type_id)"	
	$flex_assets = Get-ITGlueFlexibleAssets -filter_organization_id  $api_config.org_id -filter_flexible_asset_type_id  $api_config.flexible_asset_type_id
	
	foreach ( $flexAsset in $flex_assets.data) {
	$asset_id = $flexAsset.id
	
	if( $flex_assets.data.count -eq 0 ) {
		Write-Host "no flex assets returned"
		return False
	} else {
		Write-Host "flex assets $($SharePath)"
		
		$ret = $flex_assets.data.attributes.traits | Foreach-Object {
			if ($SharePath -eq $_.'share-path' ) {
				Write-Host "Found $($SharePath)"
				return $asset_id
			}
		}
		
	}
	}
	#Write-Host "no flex assets matched"
	return $ret
}

$result = Check-Duplicate-FlexibleAsset -SharePath '\\EC2AMAZ-75O7HIV\Share1'

if($result){
write-host "True $($result)"
} else {
write-host "false $($result)"
} 