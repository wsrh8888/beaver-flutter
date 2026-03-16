
# 1. Restore to a known good state from Git
Write-Host "Restoring lib directory from 74e0f7c..."
git checkout 74e0f7c2082ef9b6837340e1f9685fc3cf115f75 -- lib/

# 2. Perform the reorganization
$moves = @(
    @("lib/features/moment/moment_list", "lib/features/moment/list", "moment_list.dart", "list.dart"),
    @("lib/features/moment/moment_page", "lib/features/moment/detail", "moment_page.dart", "detail.dart"),
    @("lib/features/postMoment", "lib/features/moment/post", "post_moment_page.dart", "post.dart"),
    @("lib/features/createGroup", "lib/features/group/create", "create_group_page.dart", "create.dart"),
    @("lib/features/groupList", "lib/features/group/list", "group_list_page.dart", "list.dart"),
    @("lib/features/groupConfig", "lib/features/group/config", "group_config_page.dart", "config.dart"),
    @("lib/features/groupMember", "lib/features/group/member", "group_member_page.dart", "member.dart"),
    @("lib/features/contact/contact_list", "lib/features/contact/list", "contact_list.dart", "list.dart"),
    @("lib/features/newFriends", "lib/features/contact/new_friends", "new_friends_page.dart", "new_friends.dart"),
    @("lib/features/searchFriend", "lib/features/contact/search", "search_friend_page.dart", "search.dart"),
    @("lib/features/detail", "lib/features/contact/detail", "detail_page.dart", "detail.dart"),
    @("lib/features/mine", "lib/features/user/mine", "mine_page.dart", "mine.dart"),
    @("lib/features/profile", "lib/features/user/profile", "profile_page.dart", "profile.dart"),
    @("lib/features/userConfig", "lib/features/user/config", "user_config_page.dart", "config.dart"),
    @("lib/features/qrcode", "lib/features/user/qrcode", "qrcode_page.dart", "qrcode.dart"),
    @("lib/features/setting/setting_page", "lib/features/setting/main", "setting_page.dart", "main.dart"),
    @("lib/features/theme", "lib/features/setting/theme", "theme_page.dart", "theme.dart"),
    @("lib/features/update", "lib/features/setting/update", "update_page.dart", "update.dart"),
    @("lib/features/feedback", "lib/features/setting/feedback", "feedback_page.dart", "feedback.dart"),
    @("lib/features/about", "lib/features/setting/about", "about_page.dart", "about.dart"),
    @("lib/features/agreement", "lib/features/setting/legal/agreement", "agreement_page.dart", "agreement.dart"),
    @("lib/features/privacy", "lib/features/setting/legal/privacy", "privacy_page.dart", "privacy.dart"),
    @("lib/features/disclaimer", "lib/features/setting/legal/disclaimer", "disclaimer_page.dart", "disclaimer.dart"),
    @("lib/features/chat/chat_list", "lib/features/chat/list", "chat_list.dart", "list.dart"),
    @("lib/features/chat/chat_page", "lib/features/chat/detail", "chat_page.dart", "detail.dart"),
    @("lib/features/discover/discover_page", "lib/features/discover/main", "discover_page.dart", "main.dart"),
    @("lib/features/guide/guide_page", "lib/features/guide/main", "guide_page.dart", "main.dart"),
    @("lib/features/auth/pages", "lib/features/auth/login", "login_page.dart", "login.dart"),
    @("lib/features/auth/pages", "lib/features/auth/register", "register_page.dart", "register.dart")
)

Write-Host "Moving directories..."
foreach ($move in $moves) {
    if (Test-Path $move[0]) {
        if (!(Test-Path $move[1])) { New-Item -ItemType Directory -Path $move[1] -Force | Out-Null }
        if ($move[2] -and $move[3]) {
            $oldPath = Join-Path $move[0] $move[2]
            if (Test-Path $oldPath) {
                Move-Item $oldPath (Join-Path $move[1] $move[3]) -Force
            }
        }
        Move-Item "$($move[0])/*" $move[1] -Force -ErrorAction SilentlyContinue
        Remove-Item $move[0] -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 3. Global Import Update (UTF-8 safe)
Write-Host "Updating all imports..."
$importMap = @{
    "package:beaver/features/chat/chat_list/chat_list.dart" = "package:beaver/features/chat/list/list.dart"
    "package:beaver/features/chat/chat_page/chat_page.dart" = "package:beaver/features/chat/detail/detail.dart"
    "package:beaver/features/contact/contact_list/contact_list.dart" = "package:beaver/features/contact/list/list.dart"
    "package:beaver/features/contact/pages/contact_page.dart" = "package:beaver/features/contact/list/list.dart"
    "package:beaver/features/moment/pages/moment_page.dart" = "package:beaver/features/moment/list/list.dart"
    "package:beaver/features/user/pages/profile_page.dart" = "package:beaver/features/user/profile/profile.dart"
    "package:beaver/features/newFriends/new_friends_page.dart" = "package:beaver/features/contact/new_friends/new_friends.dart"
    "package:beaver/features/searchFriend/search_friend_page.dart" = "package:beaver/features/contact/search/search.dart"
    "package:beaver/features/detail/detail_page.dart" = "package:beaver/features/contact/detail/detail.dart"
    "package:beaver/features/mine/mine_page.dart" = "package:beaver/features/user/mine/mine.dart"
    "package:beaver/features/profile/profile_page.dart" = "package:beaver/features/user/profile/profile.dart"
    "package:beaver/features/userConfig/user_config_page.dart" = "package:beaver/features/user/config/config.dart"
    "package:beaver/features/qrcode/qrcode_page.dart" = "package:beaver/features/user/qrcode/qrcode.dart"
    "package:beaver/features/setting/setting_page/setting_page.dart" = "package:beaver/features/setting/main/main.dart"
    "package:beaver/features/theme/theme_page.dart" = "package:beaver/features/setting/theme/theme.dart"
    "package:beaver/features/update/update_page.dart" = "package:beaver/features/setting/update/update.dart"
    "package:beaver/features/feedback/feedback_page.dart" = "package:beaver/features/setting/feedback/feedback.dart"
    "package:beaver/features/about/about_page.dart" = "package:beaver/features/setting/about/about.dart"
    "package:beaver/features/agreement/agreement_page.dart" = "package:beaver/features/setting/legal/agreement/agreement.dart"
    "package:beaver/features/privacy/privacy_page.dart" = "package:beaver/features/setting/legal/privacy/privacy.dart"
    "package:beaver/features/disclaimer/disclaimer_page.dart" = "package:beaver/features/setting/legal/disclaimer/disclaimer.dart"
    "package:beaver/features/auth/pages/login_page.dart" = "package:beaver/features/auth/login/login.dart"
    "package:beaver/features/auth/pages/register_page.dart" = "package:beaver/features/auth/register/register.dart"
    "package:beaver/shared/widgets/beaver_header.dart" = "package:beaver/shared/ui/header/header.dart"
}

$dartFiles = Get-ChildItem -Path lib -Recurse -Include *.dart
foreach ($file in $dartFiles) {
    $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $changed = $false
    foreach ($old in $importMap.Keys) {
        if ($c.Contains($old)) {
            $c = $c.Replace($old, $importMap[$old])
            $changed = $true
        }
    }
    
    # Path-based regex replacements
    $newC = $c -replace "moment/moment_list/", "moment/list/"
    $newC = $newC -replace "moment/moment_page/", "moment/detail/"
    $newC = $newC -replace "postMoment/", "moment/post/"
    $newC = $newC -replace "chat/chat_list/", "chat/list/"
    $newC = $newC -replace "chat/chat_page/", "chat/detail/"
    
    if ($newC -ne $c -or $changed) {
        [System.IO.File]::WriteAllText($file.FullName, $newC, [System.Text.Encoding]::UTF8)
    }
}

# 4. Fix specific Type/Class Name mismatches
# MainScreen
$mainPath = "lib/features/home/main/main.dart"
if (Test-Path $mainPath) {
    $c = [System.IO.File]::ReadAllText($mainPath, [System.Text.Encoding]::UTF8)
    $c = $c -replace "ContactPage\(", "ContactListPage("
    $c = $c -replace "MomentPage\(", "MomentListPage(" 
    $c = $c -replace "ProfilePage\(", "MinePage("
    [System.IO.File]::WriteAllText($mainPath, $c, [System.Text.Encoding]::UTF8)
}

# Moment Detail
$momentDetail = "lib/features/moment/detail/detail.dart"
if (Test-Path $momentDetail) {
    $c = [System.IO.File]::ReadAllText($momentDetail, [System.Text.Encoding]::UTF8)
    $c = $c -replace "class MomentPage", "class MomentDetailPage"
    $c = $c -replace "State<MomentPage>", "State<MomentDetailPage>"
    $c = $c -replace "_MomentPageState", "_MomentDetailPageState"
    [System.IO.File]::WriteAllText($momentDetail, $c, [System.Text.Encoding]::UTF8)
}

Write-Host "Fix completed."
