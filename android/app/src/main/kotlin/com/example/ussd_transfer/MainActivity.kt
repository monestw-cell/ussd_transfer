package com.example.ussd_transfer

  import io.flutter.embedding.android.FlutterActivity
  import io.flutter.embedding.engine.FlutterEngine
  import io.flutter.plugin.common.MethodChannel
  import android.content.Intent
  import android.provider.ContactsContract
  import android.database.Cursor

  class MainActivity : FlutterActivity() {
      private val CHANNEL = "flutter/contacts"
      private var pendingResult: MethodChannel.Result? = null

      override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
          super.configureFlutterEngine(flutterEngine)
          MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
              if (call.method == "pickContact") {
                  pendingResult = result
                  val intent = Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI)
                  startActivityForResult(intent, 1001)
              } else {
                  result.notImplemented()
              }
          }
      }

      override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
          super.onActivityResult(requestCode, resultCode, data)
          if (requestCode == 1001 && resultCode == RESULT_OK) {
              val uri = data?.data ?: return
              val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)
              cursor?.use {
                  if (it.moveToFirst()) {
                      val phoneIndex = it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)
                      val phone = it.getString(phoneIndex)
                      pendingResult?.success(phone)
                  } else {
                      pendingResult?.success(null)
                  }
              }
          } else {
              pendingResult?.success(null)
          }
          pendingResult = null
      }
  }
  