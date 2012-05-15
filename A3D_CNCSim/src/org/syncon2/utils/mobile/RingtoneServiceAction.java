package   com.openplug.elips3.extension.org.syncon2.utils.mobile;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;

import android.app.AlarmManager;
import android.app.Application;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Environment;
import android.os.IBinder;
import android.os.Looper;
import android.provider.MediaStore;
import android.util.Log;

public class RingtoneServiceAction  
{
	public Application application; 
	public Application getApplication() {
		return application;
	}

	public Context context; 
	public Context getApplicationContext() {
		return context;
	}

	public AssetManager assetM; 
	public AssetManager getAssets() {
		return assetM;
	}
	public void displayNotification(String dir, String filename )
	{
		this.displayNotification(dir, filename,null);
	}
	/**
	 * 
	 * @param dir - a for alarm, n for notification, r or empty for ringtone
	 * @param filename - name of file that must be pulled
	 * @param name --wtf ... if specified will override name 
	 */
	public void displayNotification(String dir, String filename, String name )
	{
		System.out.println("ringtone in...");
		ContentResolver mCr = 	this.context.getContentResolver();
		AssetManager assetManager = getAssets();
		File newSoundFile = null;//new File("/sdcard/media/ringtone", "myringtone.mp3");
		//newSoundFile = new File("/media", "myringtone.mp3");
		
		//find new location for file
		File ringtonesDirectory = new File(  Environment.getExternalStorageDirectory() , "Ringtones/");
		
		if ( dir.equals("n"))
		{
			ringtonesDirectory = new File(  Environment.getExternalStorageDirectory() , "Notifications/");
		}		
		if (dir.equals("a"))
			{
				ringtonesDirectory = new File(  Environment.getExternalStorageDirectory() , "Alarms/");
			}		
		// have the object build the directory structure, if needed.
		ringtonesDirectory.mkdirs();

		newSoundFile = new File(ringtonesDirectory.getPath(),
				filename);
		String newFileName = newSoundFile.getName();
		//use specified name if exists
		if ( name != null )
			newFileName = name;
		//replace with just fielname
		newSoundFile = new File(ringtonesDirectory.getPath(),
				newFileName);

		//Environment
		Boolean  writeable = newSoundFile.canWrite();
		if ( newSoundFile.exists() == false )
		{
			try {
				Boolean created =   newSoundFile.createNewFile();
			} 
			catch (IOException e) {
				e.printStackTrace();
			}
		}
		InputStream fis = null;
		System.out.println("getting a file named " + filename);
		try {
			//fis = this.getApplicationContext().getAssets().open(filename);
			fis  = new BufferedInputStream(new FileInputStream(filename));

			//fis = this.getApplicationContext().getAssets().open(filename);
		} catch (IOException e) {
			System.out.println( "could not find the file input " + filename + " " +" catch exception");
			e.printStackTrace();
			Log.e(  "could not find the file input", filename + " " +"catch exception");
		} 


		try {
			byte[] readData = new byte[1024];
			// FileInputStream fis = soundFile.createInputStream();
			FileOutputStream fos = new FileOutputStream(newSoundFile);
			int i = fis.read(readData);

			while (i != -1) {
				fos.write(readData, 0, i);
				i = fis.read(readData);
			}

			fos.close();
		} catch (IOException io) {
			Boolean  why = false; 
		}
		String title = newSoundFile.getName();
		//newSoundFile = new File("/sdcard/media/ringtone", "myringtone.mp3");
		//newSoundFile = new File("file:///android_asset/",filename);    
		Boolean exists = newSoundFile.exists();		
		//final Random myRandom = new Random();
		ContentValues values = new ContentValues();
		values.put(MediaStore.MediaColumns.DATA, newSoundFile.getAbsolutePath());
		values.put(MediaStore.MediaColumns.TITLE, title);
		//MediaStore.Audio.Media.
		values.put(MediaStore.MediaColumns.DISPLAY_NAME, title);
		values.put(MediaStore.MediaColumns.MIME_TYPE, "audio/mp3");
		values.put(MediaStore.MediaColumns.SIZE, newSoundFile.length());
		values.put(MediaStore.Audio.Media.ARTIST, "Ringtones" );// R.string.app_name);
		Boolean setRingTone = false; 
		Boolean setNotification = false; 
		if ( dir.equals(null)   || dir.equals("") || dir.equals("r") )
		{
			values.put(MediaStore.Audio.Media.IS_RINGTONE, true);
			setRingTone = true; 
		}
		else
			values.put(MediaStore.Audio.Media.IS_RINGTONE, false);
		if ( dir.equals("n") )
		{
			values.put(MediaStore.Audio.Media.IS_NOTIFICATION, true);
			setNotification = true; 
		}
		else
			values.put(MediaStore.Audio.Media.IS_NOTIFICATION, false);
		if (dir.equals("a"))
			values.put(MediaStore.Audio.Media.IS_ALARM, true);
		else
			values.put(MediaStore.Audio.Media.IS_ALARM, false);
		
		values.put(MediaStore.Audio.Media.IS_MUSIC, false);

		String titleStore = MediaStore.MediaColumns.TITLE;
		//Uri uri = MediaStore.Audio.Media.getContentUriForPath(newSoundFile.getAbsolutePath());

		Uri uri = MediaStore.Audio.Media.getContentUriForPath(newSoundFile.getAbsolutePath());
		//remove current one if exists ....
		String where = "title=?";
		String[] args = new String[] { title };
		//mCr.
		//mCr.delete( uri, where, args );
		mCr.delete(uri, MediaStore.MediaColumns.DATA + "=\"" + newSoundFile.getAbsolutePath() + "\"", null);

		Uri newUri = mCr.insert(uri, values);

		//MediaStore.Audio.Media.getContentUri(arg0)
		//mCr.delete(// , where, selectionArgs)
		try {
			//AlarmManager
			if ( setRingTone )
			{
				RingtoneManager.setActualDefaultRingtoneUri(this.getApplicationContext(), RingtoneManager.TYPE_RINGTONE, newUri);
			}
			if ( setNotification ) 
			{
			RingtoneManager.setActualDefaultRingtoneUri(
					this.getApplicationContext(),
					  RingtoneManager.TYPE_NOTIFICATION,
					  newUri
					);
			}

		} catch (Throwable t) {
			Log.d("nooo", "catch exception");
		}


		/*
		int icon = R.drawable.mp_warning_32x32_n;
		CharSequence tickerText = notificationString;
		long when = System.currentTimeMillis();
		Context context = getApplicationContext();
		CharSequence contentTitle = notificationString;
		CharSequence contentText = "Hello World!";

		Intent notificationIntent = new Intent(this, MainApp.class);
		PendingIntent contentIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

		Notification notification = new Notification(icon, tickerText, when);
		notification.vibrate = new long[] {0,100,200,300};

		notification.setLatestEventInfo(context, contentTitle, contentText, contentIntent);

		String ns = Context.NOTIFICATION_SERVICE;
		NotificationManager mNotificationManager = (NotificationManager) getSystemService(ns);

		mNotificationManager.notify(1, notification);
		 */
	}

}