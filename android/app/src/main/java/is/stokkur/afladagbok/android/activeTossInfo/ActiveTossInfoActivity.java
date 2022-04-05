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

package is.stokkur.afladagbok.android.activeTossInfo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.begin.PullTossesDialog;
import is.stokkur.afladagbok.android.boats.BoatsActivity;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.dialogs.PullNetOrLineRegistrable;
import is.stokkur.afladagbok.android.more.AboutActivity;
import is.stokkur.afladagbok.android.more.LogoutActivity;
import is.stokkur.afladagbok.android.more.MoreActivity;
import is.stokkur.afladagbok.android.statistics.StatisticActivity;

public class ActiveTossInfoActivity extends BaseActivity implements PullNetOrLineRegistrable {

    public static final int ACTIVE_TOSS_PULL_REQ_CODE = 1982;
    public static final String ACTIVE_TOSS_EXTRA_NAME = "STORED_TOSS";
    public static final String ACTIVE_TOSS_POS_ID_EXTRA_NAME = "STORED_TOSS_POS_ID";
    public static final String TOSS_PULLED_AMOUNT_EXTRA_NAME = "PULLED_AMOUNT";

    @BindView(R.id.back_button)
    LinearLayout backButton;
    @BindView(R.id.back_button_text)
    TextView backButtonText;
    @BindView(R.id.header_title)
    TextView headerTitle;

    @BindView(R.id.toss_title)
    TextView tossTitle;
    @BindView(R.id.toss_date)
    TextView tossDate;
    @BindView(R.id.toss_count)
    TextView tossCount;
    @BindView(R.id.toss_pulled_count)
    TextView tossPulledCount;
    @BindView(R.id.toss_gps_lat)
    TextView tossGpsLat;
    @BindView(R.id.toss_gps_lon)
    TextView tossGpsLon;

    @BindView(R.id.menu)
    RelativeLayout menu;
    @BindView(R.id.menu_background)
    RelativeLayout menu_background;

    private Animation slideInRight;
    private Animation slideOutRight;
    private StoredToss st;
    private int positionId;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_active_toss_info);
        ButterKnife.bind(this);
        st = getIntent().getParcelableExtra(ACTIVE_TOSS_EXTRA_NAME);
        positionId = getIntent().getIntExtra(ACTIVE_TOSS_POS_ID_EXTRA_NAME,0);
        setupView();

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
    }

    @OnClick(R.id.back_button)
    public void onBackButtonClick() {
        this.finish();
    }

    @OnClick(R.id.action_button)
    public void pullToss(){
        new PullTossesDialog(this,st).show();
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

    private void setupView(){
        backButtonText.setText(R.string.back_btn);
        headerTitle.setText(R.string.drag_toss);
        backButton.setVisibility(View.VISIBLE);

        tossTitle.setText(getResources().getString(R.string.tour_toss_active_title, positionId));
        tossCount.setText(String.valueOf(st.getCount()));
        tossPulledCount.setText(String.valueOf(st.getPulledCount()));
        tossGpsLat.setText("(lat) "+st.getLatitude());
        tossGpsLon.setText("(lon) "+st.getLongitude());

        String dateTimeFormatted = st.getDateTime();

        Locale current = getResources().getConfiguration().locale;
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss",current);
        Date date;
        try {
            date = formatter.parse(st.getDateTime());
            formatter = new SimpleDateFormat("dd/MM/yyyy, hh:mm", current);
            dateTimeFormatted = formatter.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        tossDate.setText(dateTimeFormatted);
    }

    @Override
    public void registerNetPullIn(StoredToss storedToss, String amount) {
        Intent resultData = new Intent();
        resultData.putExtra(ACTIVE_TOSS_EXTRA_NAME,storedToss);
        resultData.putExtra(TOSS_PULLED_AMOUNT_EXTRA_NAME,amount);
        setResult(Activity.RESULT_OK,resultData);
        finish();
    }
}
