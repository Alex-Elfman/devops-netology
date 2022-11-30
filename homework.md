1) Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

diff --git a/CHANGELOG.md b/CHANGELOG.md
index 86d70e3..588d807 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -27,6 +27,7 @@ BUG FIXES:
 * backend/s3: Prefer AWS shared configuration over EC2 metadata credentials
 * backend/s3: Prefer ECS credentials over EC2 metadata credentials by defaul
 * backend/s3: Remove hardcoded AWS Provider messaging ([#25134](https://gith
+* command: Fix bug with global `-v`/`-version`/`--version` flags introduced
 * command/0.13upgrade: Fix `0.13upgrade` usage help text to include options
 * command/0.13upgrade: Do not add source for builtin provider ([#25215](http
 * command/apply: Fix bug which caused Terraform to silently exit on Windows
 Хеш: aefead2207ef7e2aa5dc81a34aedf0cad4c32545
 Комментарий: Update CHANGELOG.md
 
2) Какому тегу соответствует коммит 85024d3.
[centos@localhost terraform]$ git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23

diff --git a/CHANGELOG.md b/CHANGELOG.md
index 1a9dcd0..faedc8b 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -1,4 +1,4 @@
-## 0.12.23 (Unreleased)
+## 0.12.23 (March 05, 2020)
 ## 0.12.22 (March 05, 2020)

 ENHANCEMENTS:
diff --git a/version/version.go b/version/version.go
index 33ac86f..bcb6394 100644
--- a/version/version.go
+++ b/version/version.go
@@ -16,7 +16,7 @@ var Version = "0.12.23"
 // A pre-release marker for the version. If this is "" (empty string)
 КОММИТ СООТВЕТСВУЕТ ТЕГУ "V0.12.23"
 
 3) Сколько родителей у коммита b8d720? Напишите их хеши.
 Командой git co b8d720 переключился на коммит. Командой git show -s --format=%P отображаем полный хеш родителей. Вышло 2, перечислены ниже:
 56cd7859e05c36c06b56d013b55a252d0bb7e158
 9ea88f22fc6269854151c571162c5bcf958b
 Не переключаясь на коммит можно было ввести команду git show -s --format=%P b8d720
 Вывод команды git cat-file -p b8d720 | sed -ne '/^$/q;/^parent/p' | wc -l вывел количество родителей - 2
 
 4) Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
 Чтобы получить необходимые сведения вводим команду git log --pretty=oneline v0.12.23..v0.12.24, получаем:
 33ff1c03bb960b332be3af2e333462dde88b279e v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is u
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terrafor
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release

5) Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточия перечислены аргументы).
Командой git log -S'func providerSource' --oneline выводим найденные значения где есть упоминания заданной функции.
[centos@localhost terraform]$ git log -S'func providerSource' --oneline
5af1e62 main: Honor explicit provider_installation CLI config when present
8c928e8 main: Consult local directories as potential mirrors of providers
Далее просматриваем найденные коммиты:
git show 5af1e6234
здесь строка удалена
-       providerSrc := providerSource(services)
git show 8c928e835
здесь строка добавлена
+       providerSrc := providerSource(services)
Соответственно коммит, в котором создана функции providerSource - 8c928e835

6) Найдите все коммиты в которых была изменена функция globalPluginDirs
Командой git log -S'func globalPluginDirs' --oneline ищем коммиты в которых упоминается соответствующая функция
выходит 8364383 Push plugin discovery down into command package
git show 8364383 --grep 'globalPluginDirs' не находит соответствия, значит фунция не менялась в коммитах
Командой нашел файл где используется фунция git grep --break --heading -n -e 'globalPluginDirs'
commands.go
34:             GlobalPluginDirs: globalPluginDirs(),

plugins.go
10:// globalPluginDirs returns directories that should be searched for
16:func globalPluginDirs() []string {

7) Кто автор функции synchronizedWriters?
Вводим команду с флагами вывода в одну строку и автора функции:
git log -S'func synchronizedWriters' --oneline --pretty=format:'%h - %an %ae'
bdfea50 - James Bardin j.bardin@gmail.com
5ac311e - Martin Atkins mart@degeneration.co.uk
