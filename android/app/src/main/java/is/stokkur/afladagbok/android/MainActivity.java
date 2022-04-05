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

package is.stokkur.afladagbok.android;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.GnssStatus;
import android.location.GpsStatus;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.text.Html;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelProviders;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;

import javax.inject.Inject;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import dagger.android.AndroidInjector;
import dagger.android.DispatchingAndroidInjector;
import dagger.android.support.HasSupportFragmentInjector;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.boats.BoatsActivity;
import is.stokkur.afladagbok.android.extensions.ActivityExtensions;
import is.stokkur.afladagbok.android.login.LoginActivity;
import is.stokkur.afladagbok.android.login.LoginUtils;
import is.stokkur.afladagbok.android.models.ProfileResponse;
import is.stokkur.afladagbok.android.more.AboutActivity;
import is.stokkur.afladagbok.android.more.LogoutActivity;
import is.stokkur.afladagbok.android.more.MoreActivity;
import is.stokkur.afladagbok.android.onboarding.OnboardingActivity;
import is.stokkur.afladagbok.android.statistics.StatisticActivity;
import is.stokkur.afladagbok.android.terms.AcceptTermsDialog;
import is.stokkur.afladagbok.android.terms.PrivacyTermsResponse;
import is.stokkur.afladagbok.android.utils.BottomNavigationViewHelper;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.NavigationController;
import is.stokkur.afladagbok.android.utils.Persistence;
import is.stokkur.afladagbok.android.widget.RippleRelativeLayout;

public class MainActivity
        extends BaseActivity
        implements HasSupportFragmentInjector, BottomNavigationView.OnNavigationItemSelectedListener,
        View.OnClickListener, LocationUpdateListener, GPSStatusListener, ProgressListener {

    @Inject
    DispatchingAndroidInjector<Fragment> dispatchingAndroidInjector;
    @Inject
    ViewModelProvider.Factory viewModelFactory;
    @Inject
    NavigationController navigationController;
    @BindView(R.id.navigation)
    BottomNavigationView bottomNavigationView;

    @BindView(R.id.header_title)
    TextView headerTitle;
    @BindView(R.id.pull_equipment_button)
    Button pullEquipmentButton;
    @BindView(R.id.toss_out_button)
    Button layEquipmentButton;

    @BindView(R.id.action_button)
    Button actionButton;

    @BindView(R.id.menu)
    RelativeLayout menu;
    @BindView(R.id.menu_background)
    RelativeLayout menu_background;
    @BindView(R.id.active_tour_localization_status)
    RelativeLayout locationStatusLayout;
    @BindView(R.id.locationCircleView)
    ImageView locationCircleView;
    @BindView(R.id.localizationStatusRippleView)
    RippleRelativeLayout rippleLocationStatusAnim;

    ActionListener actionListener;
    private MainViewModel viewModel;

    private Animation slideDown;
    private Animation slideUp;

    private Animation slideInRight;
    private Animation slideOutRight;

    private LocationManager locMan;

    private TextView mHeaderInfo = null;
    private boolean mNotCheckingTerms = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Persistence.getStringValue(Persistence.KEY_PROFILE) == null ||
                FirebaseAuth.getInstance().getCurrentUser() == null) {
            Intent intent = new Intent(this, LoginActivity.class);
            startActivity(intent);
            finish();
            return;
        }
        if(!Persistence.getBooleanValue(Persistence.KEY_ONBOARDING_FLAG)){
            Intent intent = new Intent(this, OnboardingActivity.class);
            startActivity(intent);
        }
        silentlyUpdateProfile();

        setContentView(R.layout.activity_main);
        mHeaderInfo = findViewById(R.id.header_extra_info);

        ButterKnife.bind(this);

        setLocationListener(this, MainActivity.class.getSimpleName());
        BottomNavigationViewHelper.disableShiftMode(bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener(this);
        navigationController = new NavigationController(this);
        pullEquipmentButton.setOnClickListener(this);
        layEquipmentButton.setOnClickListener(this);
        setupViewModel();

        slideDown = AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.slide_down);
        slideUp = AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.slide_up);

        slideInRight = AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.enter_from_right);
        slideOutRight = AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.exit_to_right);
        slideOutRight.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                menu_background.setVisibility(View.GONE);
                menu.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        ProfileResponse profile = GsonInstance.sInstance.fromJson(Persistence.getStringValue(Persistence.KEY_PROFILE), ProfileResponse.class);
        ((TextView) findViewById(R.id.menu_username)).setText(profile.getProfile().getName());

        setActionButton();

        setGpsStatusListener(this);
    }

    @SuppressLint("CheckResult")
    @SuppressWarnings("ResultOfMethodCallIgnored")
    private void silentlyUpdateProfile() {
        Client.sharedClient().getClientInterface()
                .getUserInfo()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(LoginUtils::validLogin, t -> { /* Empty */ });
    }

    @Override
    public void onBackPressed() {
        if (menu.getVisibility() == View.GONE) {
            super.onBackPressed();
        } else {
            hideMenu(null);
        }
    }

    @OnClick(R.id.main_menu)
    void showMenu(View v) {
        menu.setLayoutAnimationListener(null);
        menu_background.setVisibility(View.VISIBLE);
        menu.setVisibility(View.VISIBLE);
        menu.startAnimation(slideInRight);
    }

    void hideMenu(View v) {
        menu.startAnimation(slideOutRight);
    }

    public void onMenuClick(View view) {
        if (view.getId() == R.id.menu_user){
            return;
        }
        hideMenu(view);
        Intent intent;
        switch (view.getId()) {
            case R.id.menu_user:
                break;
            case R.id.menu_stats:
                intent = new Intent(this, StatisticActivity.class);
                startActivity(intent);
                break;
            case R.id.menu_log_out:
                intent = new Intent(this, LogoutActivity.class);
                startActivity(intent);
                break;
            case R.id.menu_info:
                intent = new Intent(this, MoreActivity.class);
                startActivity(intent);
                break;
            case R.id.menu_bouts:
                intent = new Intent(this, BoatsActivity.class);
                startActivity(intent);
                break;
            case R.id.menu_back:
                break;
            case R.id.menu_about:
                intent = new Intent(this, AboutActivity.class);
                startActivity(intent);
                break;
        }
    }

    /**
     * Gets the MainViewModel and register observer(s)
     */
    private void setupViewModel() {
        viewModel = ViewModelProviders.of(this).get(MainViewModel.class);
        viewModel.getState().observe(this, state -> {
            navigationController.navigateTo(state);
        });
        viewModel.getLocation().observe(this, this::setLastKnownLocation);
    }

    public void setTotalWeight(double weight) {
        mHeaderInfo.setVisibility(View.VISIBLE);
        mHeaderInfo.setText(Html.fromHtml(getString(R.string.total_weight_caught, weight)),
                TextView.BufferType.SPANNABLE);
    }

    /**
     * Programmatically selects a navigation item in bottom navigation
     *
     * @param id
     */
    public void selectBottomNavigationItem(int id) {
        View view = bottomNavigationView.findViewById(id);
        view.performClick();
    }

    @Override
    public AndroidInjector<Fragment> supportFragmentInjector() {
        return dispatchingAndroidInjector;
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (viewModel.getState().getValue() == null) {
            bottomNavigationView.setSelectedItemId(R.id.navigation_start);
            viewModel.changeState(NavigationController.State.START);
        }
        setActionButton();

        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            AfladagbokApplication.getInstance().startSyncJob();
        }
        performTermsCheck();

        if(this.isGPSFix){
            this.setLocationStatusAsActive();
        } else {
            this.setLocationStatusAsInactive();
        }
    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        switch (item.getItemId()) {
            case R.id.navigation_start:
                viewModel.changeState(NavigationController.State.START);
                setActionButton();
                if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
                    locationStatusLayout.setVisibility(View.VISIBLE);
                    rippleLocationStatusAnim.startRippleAnimation();
                } else {
                    locationStatusLayout.setVisibility(View.GONE);
                    rippleLocationStatusAnim.stopRippleAnimation();
                }
                changeHeaderTitle(getResources().getString(R.string.catch_title));
                return true;
            case R.id.navigation_record:
                viewModel.changeState(NavigationController.State.RECORD);
                setActionButton();
                changeHeaderTitle(getResources().getString(R.string.new_catch_nav));
                return true;
            case R.id.navigation_stop:
                viewModel.changeState(NavigationController.State.STOP);
                setActionButton();
                changeHeaderTitle(getResources().getString(R.string.new_stop_nav));
                return true;
        }
        return false;
    }

    @OnClick(R.id.action_button)
    public void actionButtonClicked(View v) {
        if (actionListener != null) {
            actionListener.onActionClicked(v);
        }
    }

    private void changeHeaderTitle(String title) {
        headerTitle.setText(title);
    }

    /**
     * Resets the action button depending if the tour is active or not
     */
    public void setActionButton() {
        boolean isTripActive = Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP);

        if (viewModel.getState().getValue() == null) {
            bottomNavigationView.setSelectedItemId(R.id.navigation_start);
            viewModel.changeState(NavigationController.State.START);
        }
        String displayText = actionButton.getText().toString();
        switch (viewModel.getState().getValue()) {
            case START:
                actionButton.setEnabled(true);
                if (isTripActive) {
                    slideDown();
                }
                displayText = isTripActive ?
                        getResources().getString(R.string.action_active_start) :
                        getResources().getString(R.string.action_inactive_start);

                break;
            case STOP:
                actionButton.setEnabled(isTripActive);
                displayText = getResources().getString(R.string.action_stop);
                break;
            case RECORD:
                actionButton.setEnabled(isTripActive);
                displayText = getResources().getString(R.string.action_inactive_record);
                break;
        }
        actionButton.setText(displayText);
    }

    @Override
    public void onClick(View v) {
        if (actionListener != null) {
            actionListener.onActionClicked(v);
        }
    }

    public void setActionListener(ActionListener actionListener) {
        this.actionListener = actionListener;
    }

    public void slideDown() {
//        equipmentSelectionLayout.setVisibility(View.VISIBLE);
//        equipmentSelectionLayout.startAnimation(slideDown);
    }

    /**
     * Hides the equipment view if the tour is not active
     */
    public void setEquipmentSelection() {
//        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
//            equipmentSelectionLayout.setVisibility(View.VISIBLE);
//        } else {
//            equipmentSelectionLayout.setVisibility(View.GONE);
//        }
    }

    @Override
    public void onLocationUpdated(Location location) {
        viewModel.setLocationMutableLiveData(location);
    }

    @SuppressLint("CheckResult")
    @SuppressWarnings("ResultOfMethodCallIgnored")
    private void performTermsCheck() {
        if (mNotCheckingTerms && Persistence.getStringValue(Persistence.KEY_PROFILE) != null &&
                FirebaseAuth.getInstance().getCurrentUser() != null) {
            mNotCheckingTerms = false;
            Client.sharedClient().getClientInterface()
                    .checkForTerms()
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(this::termsCheck, t -> mNotCheckingTerms = true);
        }
    }

    private void termsCheck(PrivacyTermsResponse response) {
        if (!ActivityExtensions.isInValidState(this) && response.mNeedsToAgree) {
            AcceptTermsDialog termsDialog = new AcceptTermsDialog(this, response);
            termsDialog.setOnDismissListener(dialog -> mNotCheckingTerms = true);
            termsDialog.show();
        } else {
            mNotCheckingTerms = true;
        }
    }

    private void setLocationStatusAsActive(){
        this.rippleLocationStatusAnim.setRippleColor(getResources().getColor(R.color.ripple_green));
        this.locationCircleView.setBackground(getResources().getDrawable(R.drawable.green_circle_shape));
        this.rippleLocationStatusAnim.startRippleAnimation();
    }

    private void setLocationStatusAsInactive(){
        this.rippleLocationStatusAnim.setRippleColor(getResources().getColor(R.color.ripple_red));
        this.locationCircleView.setBackground(getResources().getDrawable(R.drawable.red_circle_shape));
        this.rippleLocationStatusAnim.startRippleAnimation();
    }

    @Override
    public void onGPSStatusChanged(boolean gpsStatus) {
        Handler mainHandler = new Handler(getMainLooper());

        Runnable myRunnable = null;

        if(gpsStatus){
            myRunnable = new Runnable() {
                @Override
                public void run() {
                    setLocationStatusAsActive();
                }
            };
        } else {
            myRunnable = new Runnable() {
                @Override
                public void run() {
                    setLocationStatusAsInactive();
                }
            };
        }
        mainHandler.post(myRunnable);
    }

    @Override
    public void onProgressFinished() {
        setActionButton();
    }

    @Override
    public void onProgressStarted() {
        actionButton.setEnabled(false);
    }
}
