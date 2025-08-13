---
title: Как сделать инстанс мастодона удобнее
---

## Раскомментировать редактирование сообщений

Вуаля - вы круче твиттера.

``` javascript
mastodon@mastodon:~/live$ git diff
diff --git a/app/javascript/mastodon/components/status_action_bar.js b/app/javascript/mastodon/components/status_action_bar.js
index 1d8fe23da..04d232be1 100644
--- a/app/javascript/mastodon/components/status_action_bar.js
+++ b/app/javascript/mastodon/components/status_action_bar.js
@@ -261,7 +261,7 @@ class StatusActionBar extends ImmutablePureComponent {
     }

     if (writtenByMe) {
-      // menu.push({ text: intl.formatMessage(messages.edit), action: this.handleEditClick });
+      menu.push({ text: intl.formatMessage(messages.edit), action: this.handleEditClick });
       menu.push({ text: intl.formatMessage(messages.delete), action: this.handleDeleteClick });
       menu.push({ text: intl.formatMessage(messages.redraft), action: this.handleRedraftClick });
     } else {
diff --git a/app/javascript/mastodon/features/status/components/action_bar.js b/app/javascript/mastodon/features/status/components/action_bar.js
index edaff959e..d98b687cb 100644
--- a/app/javascript/mastodon/features/status/components/action_bar.js
+++ b/app/javascript/mastodon/features/status/components/action_bar.js
@@ -215,7 +215,7 @@ class ActionBar extends React.PureComponent {

       menu.push({ text: intl.formatMessage(mutingConversation ? messages.unmuteConversation : messages.muteConversation), action: this.handleConversationMuteClick });
       menu.push(null);
-      // menu.push({ text: intl.formatMessage(messages.edit), action: this.handleEditClick });
+      menu.push({ text: intl.formatMessage(messages.edit), action: this.handleEditClick });
       menu.push({ text: intl.formatMessage(messages.delete), action: this.handleDeleteClick });
       menu.push({ text: intl.formatMessage(messages.redraft), action: this.handleRedraftClick });
     } else {

```

## Увеличить лимит на размер одного поста

Даёшь лонгриды в массы, к чёрту треды.

``` javascript
diff --git a/app/javascript/mastodon/features/compose/components/compose_form.js b/app/javascript/mastodon/features/compose/components/compose_form.js
index 4620d1c43..52858e72b 100644
--- a/app/javascript/mastodon/features/compose/components/compose_form.js
+++ b/app/javascript/mastodon/features/compose/components/compose_form.js
@@ -90,7 +90,7 @@ class ComposeForm extends ImmutablePureComponent {
     const fulltext = this.getFulltextForCharacterCounting();
     const isOnlyWhitespace = fulltext.length !== 0 && fulltext.trim().length === 0;

-    return !(isSubmitting || isUploading || isChangingUpload || length(fulltext) > 500 || (isOnlyWhitespace && !anyMedia));
+    return !(isSubmitting || isUploading || isChangingUpload || length(fulltext) > 10500 || (isOnlyWhitespace && !anyMedia));
   }

   handleSubmit = () => {
@@ -273,7 +273,7 @@ class ComposeForm extends ImmutablePureComponent {
           </div>

           <div className='character-counter__wrapper'>
-            <CharacterCounter max={500} text={this.getFulltextForCharacterCounting()} />
+            <CharacterCounter max={10500} text={this.getFulltextForCharacterCounting()} />
           </div>
         </div>

diff --git a/app/validators/status_length_validator.rb b/app/validators/status_length_validator.rb
index e107912b7..1023e950a 100644
--- a/app/validators/status_length_validator.rb
+++ b/app/validators/status_length_validator.rb
@@ -1,7 +1,7 @@
 # frozen_string_literal: true

 class StatusLengthValidator < ActiveModel::Validator
-  MAX_CHARS = 500
+  MAX_CHARS = 10500
   URL_PLACEHOLDER_CHARS = 23
   URL_PLACEHOLDER = 'x' * 23
```
