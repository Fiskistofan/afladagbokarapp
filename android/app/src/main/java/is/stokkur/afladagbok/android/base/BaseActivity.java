/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android.base;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.GnssStatus;
import android.location.GpsStatus;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.os.SystemClock;
import android.provider.Settings;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;

import java.util.concurrent.TimeUnit;

import io.github.inflationx.viewpump.ViewPumpContextWrapper;
import is.stokkur.afladagbok.android.BuildConfig;
import is.stokkur.afladagbok.android.GPSStatusListener;
import is.stokkur.afladagbok.android.LocationUpdateListener;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.dialogs.PromptDialogListener;
import is.stokkur.afladagbok.android.login.LoginActivity;
import is.stokkur.afladagbok.android.utils.MessageView;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 11/16/17.
 */

public class BaseActivity extends AppCompatActivity implements GpsStatus.Listener {

    // --- App Error --- //
    public static final String NO_INTERNET = "NO_INTERNET";

    /**
     * permissions request code
     */

    private final static int REQUEST_CODE_ASK_PERMISSIONS = 1;
    /**
     * Permissions that need to be explicitly requested from end user.
     */

    private static final String[] REQUIRED_SDK_PERMISSIONS = new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION};

    protected OnBackPressedListener onBackPressedListener;
    private PromptDialogListener promptDialogListener;

    private boolean mLocationCallbackRegistered = false;
    private FusedLocationProviderClient fusedLocationProviderClient = null;
    private Location lastKnownLocation = null;
    private LocationUpdateListener locationUpdateListener;
    private final LocationCallback locationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(LocationResult locationResult) {
            super.onLocationResult(locationResult);
            mLastLocationMillis = SystemClock.elapsedRealtime();
            if (locationUpdateListener != null) {
                Location lastLocation = locationResult.getLastLocation();
                locationUpdateListener.onLocationUpdated(lastLocation);
            }
        }
    };
    private boolean mAnyPermissionDenied = false;

    private long mLastLocationMillis;
    protected boolean isGPSFix = false;
    private GPSStatusListener gpsStatusListener;
    // --- Permissions --- //

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        View decorView = getWindow().getDecorView();
        setupUI(decorView);
        if (!(getBaseContext() instanceof LoginActivity)) {
            getWindow().setStatusBarColor(getResources().getColor(R.color.header_blue));
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        checkPermissions();
        registerForGPSUpdates();
    }

    @Override
    protected void onPause() {
        super.onPause();
        mAnyPermissionDenied = false;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE_ASK_PERMISSIONS) {
            if (hasPermissionRationale()) {
                requestPermissionsRationale();
                mAnyPermissionDenied = true;
            } else if (hasPermissionsGranted()) {
                registerForLocationUpdates();
            } else {
                noPermissionsGranted();
                mAnyPermissionDenied = true;
            }
        }
    }

    @SuppressLint("MissingPermission")
    private void registerForGPSUpdates(){
        if(!hasPermissionRationale()){

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                ((LocationManager) getSystemService(Context.LOCATION_SERVICE)).registerGnssStatusCallback(new GnssStatus.Callback() {
                    @Override
                    public void onStarted() {
                        super.onStarted();
                    }

                    @Override
                    public void onStopped() {
                        super.onStopped();
                    }

                    @Override
                    public void onFirstFix(int ttffMillis) {
                        super.onFirstFix(ttffMillis);
                        onGpsStatusChanged(GpsStatus.GPS_EVENT_FIRST_FIX);
                    }

                    @Override
                    public void onSatelliteStatusChanged(@NonNull GnssStatus status) {
                        super.onSatelliteStatusChanged(status);
                        onGpsStatusChanged(GpsStatus.GPS_EVENT_SATELLITE_STATUS);
                    }
                });
            } else {
                ((LocationManager) getSystemService(Context.LOCATION_SERVICE)).addGpsStatusListener(this);
            }
        }
    }

    private void checkPermissions() {
        if (hasPermissionsGranted()) {
            registerForLocationUpdates();
        } else {
            requestPermissionsRationale();
        }
    }

    private boolean hasPermissionsGranted() {
        for (String permission : REQUIRED_SDK_PERMISSIONS) {
            if (ContextCompat.checkSelfPermission(this, permission) !=
                    PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    private boolean hasPermissionRationale() {
        for (String permission : REQUIRED_SDK_PERMISSIONS) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, permission)) {
                return true;
            }
        }
        return false;
    }

    private void requestSdkPermissions() {
        ActivityCompat.requestPermissions(this, REQUIRED_SDK_PERMISSIONS, REQUEST_CODE_ASK_PERMISSIONS);
    }

    private void requestPermissionsRationale() {
        if (mAnyPermissionDenied) {
            return;
        }
        if (hasPermissionRationale()) {
            AlertDialog alertDialog = new AlertDialog.Builder(this).
                    setTitle(R.string.app_name).
                    setMessage(R.string.rationale_permissions_message).
                    setPositiveButton(R.string.ok_dialog_button, (dialog, which) -> {
                        requestSdkPermissions();
                        dialog.dismiss();
                    }).
                    setNegativeButton(R.string.cancel, (dialog, which) -> {
                        dialog.dismiss();
                        finish();
                    }).
                    setCancelable(false).
                    create();
            alertDialog.setCanceledOnTouchOutside(false);
            alertDialog.show();
        } else {
            requestSdkPermissions();
        }
    }

    private void noPermissionsGranted() {
        AlertDialog alertDialog = new AlertDialog.Builder(this).
                setTitle(R.string.app_name).
                setMessage(R.string.permissions_denied_message).
                setPositiveButton(R.string.ok_dialog_button, (dialog, which) -> {
                    Intent intent = new Intent();
                    intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                    intent.setData(Uri.fromParts("package", BuildConfig.APPLICATION_ID, null));
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    startActivity(intent);
                    dialog.dismiss();
                }).
                setNegativeButton(R.string.cancel, (dialog, which) -> {
                    dialog.dismiss();
                    finish();
                }).
                setCancelable(false).
                create();
        alertDialog.setCanceledOnTouchOutside(false);
        alertDialog.show();
    }

    // --- Permissions --- //

    public void setupUI(View view) {
        // Set up touch listener for non-text box views to hide keyboard.
        if (!(view instanceof EditText)) {
            view.setOnTouchListener((View v, MotionEvent event) -> {
                Utils.hideSoftKeyboard(BaseActivity.this);
                return false;
            });
        }
    }

    @Override
    public void onBackPressed() {
        if (onBackPressedListener == null || !onBackPressedListener.goBack()) {
            super.onBackPressed();
        }
    }

    @Override
    protected void onStop() {
        unregisterForLocationUpdates();
        super.onStop();
    }

    public void setOnBackPressedListener(OnBackPressedListener onBackPressedListener) {
        this.onBackPressedListener = onBackPressedListener;
    }

    public void setPromptDialogListener(PromptDialogListener promptDialogListener) {
        this.promptDialogListener = promptDialogListener;
    }

    public void openFragmentWithAnimation(Fragment fragment) {
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.setCustomAnimations(R.anim.enter_from_right, R.anim.exit_to_left, R.anim.enter_from_left, R.anim.exit_to_right);
        transaction.replace(R.id.container, fragment);
        transaction.commit();
    }


    public void replaceFragmentWithAnimation(Fragment fragment) {
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.setCustomAnimations(R.anim.enter_from_right, R.anim.exit_to_left, R.anim.enter_from_left, R.anim.exit_to_right);
        transaction.replace(R.id.container, fragment);
        transaction.addToBackStack(fragment.getTag());
        transaction.commit();
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(ViewPumpContextWrapper.wrap(newBase));
    }

    public void setLocationListener(LocationUpdateListener listener, String TAG) {
        this.locationUpdateListener = listener;
    }


    @NonNull
    private FusedLocationProviderClient getFusedLocationProviderClient() {
        if (fusedLocationProviderClient == null) {
            fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this);
        }
        return fusedLocationProviderClient;
    }

    // This method is only been called after the permissions have been granted.
    @SuppressLint("MissingPermission")
    private void registerForLocationUpdates() {
        if (mLocationCallbackRegistered) {
            return;
        }
        mLocationCallbackRegistered = true;
        FusedLocationProviderClient locationProviderClient = getFusedLocationProviderClient();
        LocationRequest locationRequest = LocationRequest.create();
        locationRequest.setSmallestDisplacement(100);
        locationRequest.setInterval(TimeUnit.MINUTES.toMillis(5));
        locationRequest.setFastestInterval(TimeUnit.MINUTES.toMillis(1));
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        Looper looper = Looper.getMainLooper();
        locationProviderClient.requestLocationUpdates(locationRequest, locationCallback, looper);
    }

    private void unregisterForLocationUpdates() {
        if (fusedLocationProviderClient != null) {
            fusedLocationProviderClient.removeLocationUpdates(locationCallback);
            mLocationCallbackRegistered = false;
        }
    }

    public Location getLastKnownLocation() {
        return lastKnownLocation;
    }

    public void setLastKnownLocation(Location lastKnownLocation) {
        this.lastKnownLocation = lastKnownLocation;
    }

    public void displayError(String message, boolean isError) {
        if (findViewById(R.id.message_view) != null && findViewById(R.id.message_view) instanceof MessageView) {
            MessageView messageView = findViewById(R.id.message_view);
            runOnUiThread(() -> messageView.displayError(message, isError));
        }
    }

    public void animationStopped() {
        if (promptDialogListener != null && Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            promptDialogListener.promptDialog();
            promptDialogListener = null;
        }
    }

    public void setGpsStatusListener(GPSStatusListener gpsStatusListener) {
        this.gpsStatusListener = gpsStatusListener;
    }

    @Override
    public void onGpsStatusChanged(int event) {
        switch (event) {
            case GpsStatus.GPS_EVENT_SATELLITE_STATUS:
                if (lastKnownLocation != null) {
                    isGPSFix = (SystemClock.elapsedRealtime() - mLastLocationMillis) < 5000;
                }
                break;
            case GpsStatus.GPS_EVENT_FIRST_FIX:
                isGPSFix = true;
                break;
        }
        if(gpsStatusListener != null){
            this.gpsStatusListener.onGPSStatusChanged(isGPSFix);
        }
    }
}
