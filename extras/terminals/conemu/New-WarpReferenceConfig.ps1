$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$fonts=New-Object Drawing.Text.InstalledFontCollection
if('JetBrainsMono NF' -notin $fonts.Families.Name){throw 'Crisp reference font JetBrainsMono NF is not installed'}
$source=Join-Path $PSScriptRoot 'Warp-Dark-ConEmu-Zed-Aligned.xml'
$target=Join-Path $PSScriptRoot 'Warp-Dark-ConEmu-Warp-Reference.xml'
if(Test-Path $target){throw "Refusing to overwrite $target"}
[xml]$d=Get-Content $source -Raw
$k=$d.SelectSingleNode('/key/key/key[@name=".Vanilla"]')
function Set-Setting($name,$type,$data){
 $v=$k.SelectSingleNode("value[@name='$name']")
 if(-not $v){$v=$d.CreateElement('value');$v.SetAttribute('name',$name);[void]$k.AppendChild($v)}
 $v.SetAttribute('type',$type);$v.SetAttribute('data',$data)
}
Set-Setting 'FontName' 'string' 'JetBrainsMono NF'
Set-Setting 'FontSize' 'dword' '0000000e'
Set-Setting 'FontBold' 'hex' '00'
# Explicit ClearType Natural for crisp (LOGFONT lfQuality=6 = CLEARTYPE_NATURAL_QUALITY)
# Inherited from source before; force it so generator owns the anti-alias decision.
# Switched from Inconsolata-g (grainy per user feedback at size 14) to JetBrainsMono NF for sharper Windows rendering while keeping Warp-inspired palette/canvas.
Set-Setting 'Anti-aliasing' 'ulong' '6'
Set-Setting 'Anti-aliasing2' 'hex' '01'
Set-Setting 'CenterConsolePad' 'dword' '00000010'
Set-Setting 'ColorTable00' 'dword' '00050505'
Set-Setting 'ColorTable15' 'dword' '00ffffff'
# Block cursor (style 2), blinking, color-inversion off.
# ConEmu has no cursor RGB: cbCursorColor only inverts the cell or paints
# white/black (ConEmu.l10n "cbCursorColor"). A blue block is not possible.
Set-Setting 'CursorTypeActive' 'dword' '00023242'
Set-Setting 'CursorTypeInactive' 'dword' '00823242'
$palette=$k.SelectSingleNode('key[@name="Colors"]/key[value[@name="Name" and @data="Warp Dev Dark"]]')
if($palette){
 $palette.SelectSingleNode('value[@name="Name"]').SetAttribute('data','Warp Active Dark Reference')
 $palette.SelectSingleNode('value[@name="ColorTable00"]').SetAttribute('data','00050505')
 $palette.SelectSingleNode('value[@name="ColorTable15"]').SetAttribute('data','00ffffff')
}
$d.Save($target)
Write-Output $target
