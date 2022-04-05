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

package is.stokkur.afladagbok.android.more;

import android.os.Bundle;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;

public class LogoutActivity extends BaseActivity {

    @BindView(R.id.menu)
    RelativeLayout menu;
    @BindView(R.id.menu_background)
    RelativeLayout menu_background;
    @BindView(R.id.back_button)
    LinearLayout backButton;
    @BindView(R.id.back_button_text)
    TextView backButtonText;
    @BindView(R.id.header_title)
    TextView headerTitle;
    @BindView(R.id.main_menu)
    ImageView ham_menu;

    private Animation slideInRight;
    private Animation slideOutRight;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_frag_loader);
        ButterKnife.bind(this);
        ham_menu.setVisibility(View.GONE);
        backButton.setVisibility(View.VISIBLE);
        headerTitle.setText(R.string.boat_nav);
        backButtonText.setText(R.string.back_btn);
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

        FragmentManager fragmentManager = getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        LogoutFragment fragment = new LogoutFragment();
        fragmentTransaction.add(R.id.base_content, fragment);
        fragmentTransaction.commit();
    }

    @OnClick(R.id.back_button)
    public void OnBackButtonClick() {
        onBackPressed();
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

    void hideMenu(View v){
        menu.startAnimation(slideOutRight);
    }

    public void onMenuClick(View view) {
        /* Implement menu click if menu is visible */
    }

}
