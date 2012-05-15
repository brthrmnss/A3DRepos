package com.openplug.elips3.extension.org.syncon2.utils.mobile;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

import android.content.Intent;
import android.content.res.AssetManager;
import android.net.Uri;
import android.util.Log;

import com.openplug.elips3.extension.*;

class AndroidExtensions_OpenPlugImpl implements AndroidExtensions_OpenPlug
{
private static final String TAG = "ui";

public void setRingtone(ASContext ctxt, ASObject thiz, String l_url)
{
	this.setRingtoneA( "r", l_url);
} 
//void displayFiles (AssetManager mgr, String path) {
//    try {
//        String list[] = mgr.list(path);
//        if (list != null)
//            for (int i=0; i<list.length; ++i)
//                {
//                    Log.v("Assets:", path +"/"+ list[i]);
//                    displayFiles(mgr, path + "/" + list[i]);
//                }
//    } catch (IOException e) {
//        Log.v("List error:", "can't list" + path);
//    }
//
//}

private void setRingtoneA(String actionType, String l_url) {
	RingtoneServiceAction r = new RingtoneServiceAction();
	r.context =ElipsAndroidUtils.getContext();// this.getApplicationContext(); 
	this.displayFiles(ElipsAndroidUtils.getContext().getApplicationContext().getAssets() , "",0);
	File f = ElipsAndroidUtils.getContext().getFilesDir();
	l_url = replace(l_url, "//", "" );
	File f2 = new File(f.getPath(), l_url); 
	String list[]  = f.list();
	Boolean exists = f2.exists();
	  f = ElipsAndroidUtils.getContext().getFilesDir().getParentFile();
	l_url = replace(l_url, "//", "" );
	  f2 = new File(f.getPath(),"elips_fs/"+ l_url); 
	  list   = f.list();
	  exists = f2.exists();
	r.displayNotification(actionType, f2.getPath()  ); 
}

void displayFiles (AssetManager mgr, String path, int level) {

    Log.d(TAG,"enter displayFiles("+path+")");
   try {
       String list[] = mgr.list(path);
        Log.d(TAG,"L"+level+": list:"+ Arrays.asList(list));

       if (list != null)
           for (int i=0; i<list.length; ++i)
               {
                   if(level>=1){
                     displayFiles(mgr, path + "/" + list[i], level+1);
                   }else{
                        displayFiles(mgr, list[i], level+1);
                   }
               }
   } catch (IOException e) {
       Log.d(TAG,"List error: can't list" + path);
   }

}



static String replace(String str, String pattern, String replace) {
    int s = 0;
    int e = 0;
    StringBuffer result = new StringBuffer();

    while ((e = str.indexOf(pattern, s)) >= 0) {
        result.append(str.substring(s, e));
        result.append(replace);
        s = e+pattern.length();
    }
    result.append(str.substring(s));
    return result.toString();
}

public void setNotification(ASContext ctxt, ASObject thiz, String l_url)
{
//	RingtoneServiceAction r = new RingtoneServiceAction();
//	r.context =ElipsAndroidUtils.getContext();// this.getApplicationContext(); 
//	r.displayNotification("n", l_url); 
	this.setRingtoneA( "n", l_url);
}  

public void setAlarm(ASContext ctxt, ASObject thiz, String l_url)
{ 
    // TODO: Add your code here
}
 
public void goToStore(ASContext ctxt, ASObject thiz, String l_query, String l_pub)
{ 
	Intent intent = new Intent(Intent.ACTION_VIEW);
	intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	if ( l_query.equals('')==false)
	{
		intent.setData(Uri.parse("http://market.android.com/search?q="+l_query)); 
	}
	if ( l_pub.equals('')==false)
	{
		intent.setData(Uri.parse("http://market.android.com/search?q="+l_pub)); 
	}
	//startActivity(intent);
	ElipsAndroidUtils.getContext().startActivity(intent);
}

public void rateApp(ASContext ctxt, ASObject thiz, String l_apppackage)
{
	//ElipsAndroidUtils.getContext().startActivity(intent);
	Intent intent = new Intent(Intent.ACTION_VIEW);
	intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

	intent.setData(Uri.parse("market://details?id="+l_apppackage));
	//startActivity(intent);
	ElipsAndroidUtils.getContext().startActivity(intent);
}

public void shareApp(ASContext ctxt, ASObject thiz, String l_subject, String l_text, String l_intentName)
{
	Intent intent = new Intent(Intent.ACTION_SEND);
	//intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	intent.setType("text/plain");

	intent.putExtra(Intent.EXTRA_SUBJECT, l_subject);
	intent.putExtra(Intent.EXTRA_TEXT, l_text ); 
	// "Check out this cool app http://market.android.com/details?id=com.example.yourpackagename");

	Intent chooser = Intent.createChooser(intent, l_intentName);
	chooser.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	
	//startActivity(chooser);
	ElipsAndroidUtils.getContext().startActivity(chooser);
}


}
