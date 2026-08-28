# Generates the 1024x1024 master app icon used by flutter_launcher_icons.
Add-Type -AssemblyName System.Drawing

$size = 1024
$outDir = Join-Path $PSScriptRoot '..\assets\icon'
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$outFile = Join-Path $outDir 'app_icon.png'

$bmp = New-Object System.Drawing.Bitmap($size, $size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Brand gradient (soft turquoise).
$rect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
$top = [System.Drawing.Color]::FromArgb(255, 30, 190, 178)
$bottom = [System.Drawing.Color]::FromArgb(255, 11, 118, 112)
$bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $top, $bottom, 55.0)
$g.FillRectangle($bg, $rect)

$points = @(
    (New-Object System.Drawing.PointF(248, 646)),
    (New-Object System.Drawing.PointF(416, 502)),
    (New-Object System.Drawing.PointF(584, 574)),
    (New-Object System.Drawing.PointF(776, 386))
)

$pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::White, 78)
$pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawLines($pen, [System.Drawing.PointF[]]$points)

$g.Dispose()
$bmp.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Output "Wrote $outFile"
