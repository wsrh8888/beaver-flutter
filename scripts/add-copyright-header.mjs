/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 批量为 lib 下 .dart 添加或更新文件头版权注释（中英双语）。
 * 用法（仓库根目录）: node scripts/add-copyright-header.mjs
 */

import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const repoRoot = path.resolve(__dirname, '..')
const srcRoot = path.join(repoRoot, 'lib')

const MARKER = 'SPDX-License-Identifier: MIT'
const HEADER_VERSION = 'beaver-flutter-header-v1'

const DART_HEADER = `/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * ${HEADER_VERSION}
 */

`

const EXT_SET = new Set(['.dart'])

/** 跳过生成文件 */
const SKIP_NAME_RE = /\.(g|freezed|mocks)\.dart$/i
const SKIP_NAMES = new Set(['generated_plugin_registrant.dart'])

/** 匹配旧版 / 任意 SPDX 文件头（用于升级替换） */
const DART_HEADER_RE = /^(\uFEFF)?\/\*\*[\s\S]*?\*\/\s*/

function walk(dir, files = []) {
  if (!fs.existsSync(dir)) {
    return files
  }
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name)
    const stat = fs.statSync(full)
    if (stat.isDirectory()) {
      if (name === '.dart_tool' || name === 'build' || name === '.git') {
        continue
      }
      walk(full, files)
      continue
    }
    if (!EXT_SET.has(path.extname(name))) {
      continue
    }
    if (SKIP_NAMES.has(name) || SKIP_NAME_RE.test(name)) {
      continue
    }
    files.push(full)
  }
  return files
}

function stripBom(content) {
  if (content.charCodeAt(0) === 0xFEFF) {
    return content.slice(1)
  }
  return content
}

function isOurHeader(content) {
  const head = content.slice(0, 1200)
  return head.includes(MARKER) || /Copyright\s*\(c\)\s*20\d{2}.*Beaver/i.test(head)
}

function hasCurrentVersion(content) {
  return content.slice(0, 1200).includes(HEADER_VERSION)
}

function stripExistingHeader(content) {
  let body = stripBom(content)

  if (DART_HEADER_RE.test(body) && isOurHeader(body)) {
    body = body.replace(DART_HEADER_RE, '')
  }

  // 再保险：以 SPDX / Beaver Copyright 开头的块注释
  if (isOurHeader(body) && body.trimStart().startsWith('/**')) {
    const end = body.indexOf('*/')
    if (end >= 0) {
      body = body.slice(end + 2).replace(/^\r?\n+/, '')
    }
  }

  return body
}

function injectHeader(content) {
  if (hasCurrentVersion(content)) {
    return null
  }

  const body = stripExistingHeader(content)
  return `${DART_HEADER}${body}`
}

function main() {
  const files = walk(srcRoot)
  let changed = 0
  let skipped = 0

  for (const file of files) {
    const original = fs.readFileSync(file, 'utf8')
    const next = injectHeader(original)
    if (next == null) {
      skipped += 1
      continue
    }
    if (next === original) {
      skipped += 1
      continue
    }
    changed += 1
    const rel = path.relative(repoRoot, file)
    fs.writeFileSync(file, next, 'utf8')
    console.log(`updated: ${rel}`)
  }

  console.log(`\nDone. files=${files.length}, updated=${changed}, skipped=${skipped}`)
}

main()
