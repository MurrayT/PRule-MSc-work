package com.example.mycoolapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

// I am creating a comment that is very very long to demonstrate how the line wrapping system works.  You should see a symbol to annotate that it has been wrapped to the next line.
public class Data_Bus extends Activity {
	Button Next;
	TextView textdisplay1, textdisplay2; 
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.adc_databustest);
		Next = (Button) findViewById (R.id.checkButton); 
		textdisplay1 = (TextView) findViewById (R.id.tvTop);
		textdisplay2 = (TextView) findViewById (R.id.tvBottom);
		       
	}
}
