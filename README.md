# fsvideo
Мобильный клиент fs.to и ex.ua - двух крупнейших сервисов, предоставляющих мультимедийный контент в Украине.

В приложение реализованый поиск по обоим сайтам, добавление в "Избранные", закачка видеофайлов на телефон.
Можно пролистывать картинки с описания к фильмам, читать коментарии пользователей. 
Есть удобная перемотка по свайпу, приложение также запоминает позицию на которой пользователь закончил просмотр.

В то время как на андроиде давно есть FSVideoBox, на iOS приходилось кусать локти... до этого момента.

Я пытался выложить приложение в App Store, но не сложилось.
Чтоб не рисковать потерять аккаунт в App Store и при этом чтоб приложение не утерялось я решил выложить его в свободный доступ на GitHub.

# Как собрать
## Xcode 
Если у Вас компьютер на macOS (Macbook / iMac / Mac Mini / Mac Pro) вы можете собрать себе проект с кода.
Для этого раньше нужно было платить 100 долларов в год Apple, но сейчас это уже не нужно.
Есть в интернете полно гайдов как собрать приложение себе на телефон, я процитирую один из них:

Requirements: You must be running iOS 9 on your devices (iPhone or iPad), latest Xcode 7 and you’ll need a free developer account, which lets you “test on device”.

Step 1: Launch your application which you want to run on device.

Step 2: Connect your iOS device via USB.

Step 3: In the drop down device selection menu, select your device (not a simulator).

Step 4: Wait as Xcode 7 indexes and processes symbol files. This may take a while as well, so be patient. Once complete, the status will say Ready.

Step 5: Click the Play button (Run application). You’ll likely get an error that says “failed to code sign”. That’s okay. Click Fix Issue and click Add to log in with your developer account. Remember, you don’t need a paid developer account, but you will need a free developer account (Apple ID). If you don’t have a developer account, create one by clicking Join a Program instead.

Step 6: Once you log in, click the Play button again to proceed with the compile. You may receive another error that says An App ID with Identifier…is not available. Please enter a different string. To fix this, click the General tab, and give the Bundle Identifier a unique name (delete the name between the two dots and add your own name. Leave the prefix and suffix as it is).

Step 7: Click the Play button once more. The compile should complete, and you’ll see the app that you compiled appear on your iOS device’s Home screen.

Step 8: You’ll need to enable access to the app by trusting the developer on your iOS device. This can be done by going to Settings → General → Profile and tapping on the Developer app and granting access.

Step 9: Launch the app on your device Home screen, and iOS should allow you to use it. Happy code signing :).

Note: you cannot test Push Notification and In-App purchase on Free Membership Account.

## Для Windows
Если Вам не повезло и у вас не мак, а компьютер на винде, поставьте себе виртуальную машинку аля VMWare или VirtualBox с OS X на борту и см. п. 1. 
Минимальные требования по машинке: OS X 10.10 или старше, Xcode 7. 
Или найдите друга с макбуком и попросите его собрать Вам приложение.

## OTA
Если Вы очень добрый человек и хотите шарить приложение Вашим друзьям по OTA, Вы можете к примеру воспользоваться сервисом Fabric или TestFlight для этого. Вам нужен будет полноценный аккаунт разработчика за 100 долларов в год с ограничением 100 устройств на профиль.

# Доступ
Контент по дефолту доступен только в Украине, но в приложение зашита поддержка прокси.
Т.е. в России, Республике Белорусь и других странах тоже все будет работать.
Единственный момент - в Украине работает и онлайн, и скачивание. В остальных странах только скачивание.
Это связано с тем, что я не смог подхачить системный плеер на работу с прокси.

# Ограничения
Запрещается выкладывать приложение на публичные сервисы, предлагающие раздачу приложение онлайн с использованием Enterprise учетки.
Пример таких сайтов: f0x.pw.
Почему запрещается? Да потому что рано или поздно Apple на них выйдет, накроет их учетку и мою вместе с ними. А я за нее 100 баков плачу.
Также запрещается продавать приложение или выкладывать его модификации с встроенной рекламой - это нарушение законодательства в многих странах. Называется "Продажа краденого". Эти проблемы ни мне, ни Вам не нужны.
Запрещается также с настроек убирать ссылки на группы в вк и фейсбуке, править файл "About.rtf", электронный адрес поддержки приложения без согласия автора.

# Заключение
Качайте сорцы, ставьте себе и наслаждайтесь. Делал для себя и старался максимально комфортно.
Буду рад также видеть ваши пул реквесты.
