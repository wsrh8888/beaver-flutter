
# 1. Delete redundant old style pages
$redundantPaths = @(
    "lib/features/home/pages",
    "lib/features/contact/pages",
    "lib/features/user/pages",
    "lib/features/moment/pages"
)

foreach ($path in $redundantPaths) {
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force
        Write-Host "Removed $path"
    }
}

# 2. Fix lib/router/router.dart specifically
$routerPath = "lib/router/router.dart"
if (Test-Path $routerPath) {
    $c = [System.IO.File]::ReadAllText($routerPath, [System.Text.Encoding]::UTF8)
    $c = $c -replace "import 'package:beaver/features/home/pages/main_screen.dart';", "import 'package:beaver/features/home/main/main.dart';"
    $c = $c -replace "import 'package:beaver/features/auth/register/register.dart';", "import 'package:beaver/features/auth/register/register.dart';\nimport 'package:beaver/router/modules/auth_router.dart';"
    $c = $c -replace "const MainScreen\(\)", "const MainScreen()"
    [System.IO.File]::WriteAllText($routerPath, $c, [System.Text.Encoding]::UTF8)
}

Write-Host "Cleanup completed."
