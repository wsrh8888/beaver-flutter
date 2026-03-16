
$filesToFix = Get-ChildItem -Path lib -Recurse -Include *.dart

foreach ($file in $filesToFix) {
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $oldC = $c
    
    # 1. Fix BeaverToast calls
    $c = $c -replace "BeaverToast.show\('", "BeaverToast.show(context, '"
    
    # 2. Fix Database Table names
    $c = $c -replace "_database.conversations", "_database.chatConversations"
    $c = $c -replace "select\(conversations\)", "select(chatConversations)"
    $c = $c -replace "update\(conversations\)", "update(chatConversations)"
    $c = $c -replace "delete\(conversations\)", "delete(chatConversations)"
    
    # 3. Companion names
    $c = $c -replace "ConversationsCompanion", "ChatConversationsCompanion"
    
    # 4. Fix ChatModel mappings
    $c = $c -replace "conv.name ??", "conv.title ??"
    $c = $c -replace "conv.name", "conv.title"
    
    # 5. Fix Friend table mappings
    if ($file.FullName -contains "contact\list\data\repositories\repository.dart") {
        $c = $c -replace "friend.nickname", "friend.sendUserNotice ?? 'Unknown'"
        $c = $c -replace "friend.remark", "friend.sendUserNotice"
        $c = $c -replace "friend.avatar", "''"
    }

    # 6. Fix RegisterPage constant constructor issues
    $c = $c -replace "AppRoutes.forgetPassword", "AuthRoutes.forgotPassword"
    $c = $c -replace "AppRoutes.register", "AuthRoutes.register"

    if ($c -ne $oldC) {
        [System.IO.File]::WriteAllText($file.FullName, $c, [System.Text.Encoding]::UTF8)
    }
}

# 7. Fix RegisterPage constructor in registration page itself
$regPage = "lib/features/auth/register/register.dart"
if (Test-Path $regPage) {
    $c = [System.IO.File]::ReadAllText($regPage, [System.Text.Encoding]::UTF8)
    if (!($c -contains "import 'package:beaver/features/auth/data/repositories/auth_repository.dart';")) {
        $c = "import 'package:beaver/features/auth/data/repositories/auth_repository.dart';\n" + $c
    }
    [System.IO.File]::WriteAllText($regPage, $c, [System.Text.Encoding]::UTF8)
}

# 8. Do the same for login.dart
$loginPage = "lib/features/auth/login/login.dart"
if (Test-Path $loginPage) {
    $c = [System.IO.File]::ReadAllText($loginPage, [System.Text.Encoding]::UTF8)
    if (!($c -contains "import 'package:beaver/features/auth/data/repositories/auth_repository.dart';")) {
        $c = "import 'package:beaver/features/auth/data/repositories/auth_repository.dart';\n" + $c
    }
    [System.IO.File]::WriteAllText($loginPage, $c, [System.Text.Encoding]::UTF8)
}
