# Changelog

## [1.8.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.7.0...v1.8.0) (2025-01-26)


### Features

* add chooseImports action ([#19](https://github.com/nvim-java/nvim-java-refactor/issues/19)) ([5d15bd6](https://github.com/nvim-java/nvim-java-refactor/commit/5d15bd646f73073244e4f5da64905ba0b2b592e5))

## [1.7.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.6.0...v1.7.0) (2025-01-21)


### Features

* add handler for overrideMethodsPrompt action ([#16](https://github.com/nvim-java/nvim-java-refactor/issues/16)) ([2c281a1](https://github.com/nvim-java/nvim-java-refactor/commit/2c281a110fd616ce10c44963e63e13bdf9e638d7))

## [1.6.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.5.0...v1.6.0) (2024-07-25)


### Features

* add support for move refactoring code commands ([731a6f5](https://github.com/nvim-java/nvim-java-refactor/commit/731a6f50e656ae6dfc11d0517650ac179a669e11))
* move all client commands to java-refactor ([#14](https://github.com/nvim-java/nvim-java-refactor/issues/14)) ([2c239b8](https://github.com/nvim-java/nvim-java-refactor/commit/2c239b84b84986808c9f351e959b2e9422bbc890))


### Bug Fixes

* throws an error when there is refactor edit error ([1ad4911](https://github.com/nvim-java/nvim-java-refactor/commit/1ad49115898c1a03af23ec5058c1df6268b712a9))

## [1.5.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.4.0...v1.5.0) (2024-07-17)


### Features

* add moveType and moveStaticMember code actions ([35d8a83](https://github.com/nvim-java/nvim-java-refactor/commit/35d8a8341cc1d0ca6febed5910adb8f3d8ad26fd))

## [1.4.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.3.0...v1.4.0) (2024-07-13)


### Features

* add more refactor commands ([6adf3a7](https://github.com/nvim-java/nvim-java-refactor/commit/6adf3a7340ea6aea158719609802a444dbc37d93))

## [1.3.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.2.0...v1.3.0) (2024-07-12)


### Features

* add ui selection for extractField command ([4b1ffbb](https://github.com/nvim-java/nvim-java-refactor/commit/4b1ffbb4a1591f989dce3f5bbcb3af01b169d0d4))

## [1.2.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.1.0...v1.2.0) (2024-07-11)


### Features

* add apply refactoring command handler ([f1ae757](https://github.com/nvim-java/nvim-java-refactor/commit/f1ae757c648253cf88b2f06c3bff6042aacad6d4))
* add message when unsupported command is ran ([091bdb3](https://github.com/nvim-java/nvim-java-refactor/commit/091bdb348fe0c7b9d1fb69133ac08a9ef49451ea))

## [1.1.0](https://github.com/nvim-java/nvim-java-refactor/compare/v1.0.0...v1.1.0) (2024-07-10)


### Features

* add support for more refactoring commands ([c281695](https://github.com/nvim-java/nvim-java-refactor/commit/c281695d2daa99f34f5d4db74d90dc3a4f2eb991))

## 1.0.0 (2024-05-02)


### Features

* add extract variable command ([#5](https://github.com/nvim-java/nvim-java-refactor/issues/5)) ([7e7bbea](https://github.com/nvim-java/nvim-java-refactor/commit/7e7bbea13286e1cdf2e344a3158f9bafbf7c9877))
* init commit ([5ceae25](https://github.com/nvim-java/nvim-java-refactor/commit/5ceae254705c281b1fcdf4093190e821eed74a9e))


### Bug Fixes

* **ci:** missing token for stylua ([8aed200](https://github.com/nvim-java/nvim-java-refactor/commit/8aed2008d2c2cecfe62c2bd18d04634aa3230813))

## [1.2.0](https://github.com/nvim-java/nvim-java/compare/v1.1.0...v1.2.0) (2024-03-23)


### Features

* **conf:** capability to remove dap related notifications ([9f9b785](https://github.com/nvim-java/nvim-java/commit/9f9b785e9f8a452e7bd56d809578efc1c5908b6b))


### Bug Fixes

* jdtls wont start up after new mason versioned package ([#147](https://github.com/nvim-java/nvim-java/issues/147)) ([8945fc1](https://github.com/nvim-java/nvim-java/commit/8945fc16452e9c6748194ac5e24379a8ccdcf3a2))
* **test:** tests are hanging after vim.ui.select to handle async ui change. ([#139](https://github.com/nvim-java/nvim-java/issues/139)) ([#140](https://github.com/nvim-java/nvim-java/issues/140)) ([ba1146e](https://github.com/nvim-java/nvim-java/commit/ba1146ebe859dbd2ea4fded68bb8b04805a894ec))

## [1.1.0](https://github.com/nvim-java/nvim-java/compare/v1.0.6...v1.1.0) (2024-03-17)


### Features

* APIs to run application ([#136](https://github.com/nvim-java/nvim-java/issues/136)) ([a0c6c1b](https://github.com/nvim-java/nvim-java/commit/a0c6c1b7dbf547b88350d6ffd033c61451a067eb))

## [1.0.6](https://github.com/nvim-java/nvim-java/compare/v1.0.5...v1.0.6) (2024-03-03)


### Bug Fixes

* lombok APIs with parameters are not working ([#129](https://github.com/nvim-java/nvim-java/issues/129)) ([5133a21](https://github.com/nvim-java/nvim-java/commit/5133a21ffc6b9545d9785721d34a212120a22749))

## [1.0.5](https://github.com/nvim-java/nvim-java/compare/v1.0.4...v1.0.5) (2024-03-01)


### Bug Fixes

* sometimes dap is not configured correctly ([#126](https://github.com/nvim-java/nvim-java/issues/126)) ([4f1f310](https://github.com/nvim-java/nvim-java/commit/4f1f31094632342cc45902276d11971507c415e0))

## [1.0.4](https://github.com/nvim-java/nvim-java/compare/v1.0.3...v1.0.4) (2024-01-13)


### Miscellaneous Chores

* release 1.0.4 ([a268bdd](https://github.com/nvim-java/nvim-java/commit/a268bddafec62282d1e7e5ad85d34696bf5dd027))

## [1.0.3](https://github.com/nvim-java/nvim-java/compare/v1.0.2...v1.0.3) (2024-01-07)


### Bug Fixes

* java-debug fails due to unavailablity of v0.52.0 ([#105](https://github.com/nvim-java/nvim-java/issues/105)) ([f20e49f](https://github.com/nvim-java/nvim-java/commit/f20e49fbfa84a73f371ba9bd925d19c57f0cdd70))

## [1.0.2](https://github.com/nvim-java/nvim-java/compare/v1.0.1...v1.0.2) (2023-12-17)


### Bug Fixes

* user jdtls setup config wont override the default config ([#91](https://github.com/nvim-java/nvim-java/issues/91)) ([fa14d06](https://github.com/nvim-java/nvim-java/commit/fa14d065d3e5d7402d8bde6ebb2099dfc9f29e3f))

## [1.0.1](https://github.com/nvim-java/nvim-java/compare/v1.0.0...v1.0.1) (2023-12-13)


### Bug Fixes

* goto definition error out due to buffer is not modifiable ([#74](https://github.com/nvim-java/nvim-java/issues/74)) ([d1233cc](https://github.com/nvim-java/nvim-java/commit/d1233ccc101866bcbea394c51b7c0780bf98bb9d))

## 1.0.0 (2023-12-10)


### ⚠ BREAKING CHANGES

* go from promises to co-routines ([#30](https://github.com/nvim-java/nvim-java/issues/30))
* change the project structure according to new core changes ([#27](https://github.com/nvim-java/nvim-java/issues/27))

### Features

* add API to open test reports ([#35](https://github.com/nvim-java/nvim-java/issues/35)) ([1fb58a6](https://github.com/nvim-java/nvim-java/commit/1fb58a6f0fb20253de3542a4ea950f435378ed30))
* add capability to lsp actions in .class files ([#11](https://github.com/nvim-java/nvim-java/issues/11)) ([8695b99](https://github.com/nvim-java/nvim-java/commit/8695b9972a40ee5eec2e4a05208db29db56b8a90))
* add commands for lua APIs ([#43](https://github.com/nvim-java/nvim-java/issues/43)) ([62bf7f7](https://github.com/nvim-java/nvim-java/commit/62bf7f79ed37ebf02b2ad1c670cc495105d025ad))
* add config option to install jdk17 via mason ([29e6318](https://github.com/nvim-java/nvim-java/commit/29e631803903b52eb070ec7f069db8a44081d925))
* add editor config ([01a6c15](https://github.com/nvim-java/nvim-java/commit/01a6c1534e80c7cfbdde58e5e4962cbf32e5cd80))
* add lint & release-please workflows ([#67](https://github.com/nvim-java/nvim-java/issues/67)) ([0751359](https://github.com/nvim-java/nvim-java/commit/0751359c08e6305ec031790f0c1fdb1091b3e03b))
* add plugin manager for testing ([1feb82e](https://github.com/nvim-java/nvim-java/commit/1feb82e5576b468f7e0ab7c87c6f19c8db7800aa))
* add test current method API ([#31](https://github.com/nvim-java/nvim-java/issues/31)) ([a5e5adb](https://github.com/nvim-java/nvim-java/commit/a5e5adb60a726ece9298723bd2c2e6000efc3731))
* auto configure jdtls and dap at start up ([#2](https://github.com/nvim-java/nvim-java/issues/2)) ([83e25bb](https://github.com/nvim-java/nvim-java/commit/83e25bb827aee6b52b389f608eca01a01fa7ee2a))
* auto refresh the mason registory when pkgs are not available ([#41](https://github.com/nvim-java/nvim-java/issues/41)) ([0edb02c](https://github.com/nvim-java/nvim-java/commit/0edb02c12ca5b8750f9734562d7ea2213e3c8442))
* Create FUNDING.yml ([f23b56e](https://github.com/nvim-java/nvim-java/commit/f23b56e3fc80156781e7d3029c365be766e3af24))
* extract debug & run APIs for current test class ([#14](https://github.com/nvim-java/nvim-java/issues/14)) ([b5368b2](https://github.com/nvim-java/nvim-java/commit/b5368b20fb2479e0571675d1646cce248e5a809b))
* **ui:** add visual indication for dap configuration status ([#60](https://github.com/nvim-java/nvim-java/issues/60)) ([7f5475e](https://github.com/nvim-java/nvim-java/commit/7f5475ebac07b7522afc24b2d6ff6afe5e1d373d))


### Bug Fixes

* 0.40.1 failure on install ([f16b08b](https://github.com/nvim-java/nvim-java/commit/f16b08b277400c1965679be6f5178cb5d04b6f25))
* build badge ([0af982e](https://github.com/nvim-java/nvim-java/commit/0af982e895e3eabfcae97d922eac733a758d5757))
* build shields badge ([db7b333](https://github.com/nvim-java/nvim-java/commit/db7b3335dfc1a38181b1702449aae50589382ae8))
* **ci:** invalid vim-doc name ([#16](https://github.com/nvim-java/nvim-java/issues/16)) ([4a64bb6](https://github.com/nvim-java/nvim-java/commit/4a64bb6eef90c857913780bbde92ad7411002eef))
* error in error handler function ([#24](https://github.com/nvim-java/nvim-java/issues/24)) ([2fd3979](https://github.com/nvim-java/nvim-java/commit/2fd39790df73669e2384f3dd1acd3c1322203dfb))
* error when java.setup with no table ([#56](https://github.com/nvim-java/nvim-java/issues/56)) ([18bb0ab](https://github.com/nvim-java/nvim-java/commit/18bb0abe4450bc7405f78f0d8e37f9787315102c))
* jdk auto_install should be true by default ([#59](https://github.com/nvim-java/nvim-java/issues/59)) ([2c82759](https://github.com/nvim-java/nvim-java/commit/2c827599f099d8b80cfdd74690ff807309748930))
* server module was moved from prev location in java-core ([#22](https://github.com/nvim-java/nvim-java/issues/22)) ([a27c215](https://github.com/nvim-java/nvim-java/commit/a27c2159c7ef5620137916419ed689501c6264ae))
* when launched first time lazy covers mason nvim window ([#52](https://github.com/nvim-java/nvim-java/issues/52)) ([340cad5](https://github.com/nvim-java/nvim-java/commit/340cad58b382b9e3f310fbc50427691f5b46af2f))


### Code Refactoring

* change the project structure according to new core changes ([#27](https://github.com/nvim-java/nvim-java/issues/27)) ([7c7b772](https://github.com/nvim-java/nvim-java/commit/7c7b772151b67bea7eb3bd96f78cfa337d106d8d))
* go from promises to co-routines ([#30](https://github.com/nvim-java/nvim-java/issues/30)) ([737792d](https://github.com/nvim-java/nvim-java/commit/737792d2595a01d0e3c491dcae907a7041d27c1b))
