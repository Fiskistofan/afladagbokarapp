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

package is.stokkur.afladagbok.android.utils;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.TransitionDrawable;
import android.os.Build;
import androidx.interpolator.view.animation.FastOutSlowInInterpolator;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.R;

/**
 * Created by annalaufey on 11/29/17.
 */

public class CustomSwitchButton extends RelativeLayout {

    @BindView(R.id.off_view)
    View offView;
    @BindView(R.id.negative_txt)
    TextView negativeText;
    @BindView(R.id.positive_txt)
    TextView positiveText;

    TransitionDrawable crossfader;
    int MAX_MARGIN = 0;

    boolean isPositive = false;

    public CustomSwitchButton(Context context) {
        super(context);
        init();
    }

    public CustomSwitchButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CustomSwitchButton(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    public CustomSwitchButton(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }


    private void init() {
        inflate(getContext(), R.layout.switch_button_layout, this);
        ButterKnife.bind(this);
        buttonAnimation();
    }


    @OnClick(R.id.switch_button)
    public void onSwitch() {
        if (isPositive) {
            slideSwitchToTheLeft();
            isPositive = false;
        } else {
            slideSwitchToTheRight();
            isPositive = true;
        }
    }

    public boolean isPositive() {
        return isPositive;
    }

    public void setPositive(boolean positive) {
        isPositive = positive;
    }


    public void setButtonState(boolean sIsPositive) {
        if (sIsPositive) {
            slideSwitchToTheRight();
            isPositive = true;
        } else {
            isPositive = false;
        }
    }

    /**
     * Animates the sliding button. Pushes it to the side with margin
     * and uses transitionDrawable to switch colors
     *
     * @param
     */
    private void buttonAnimation() {
        final View sl = findViewById(R.id.switch_layout);
        sl.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                sl.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) offView.getLayoutParams();
                layoutParams.width = (int) (sl.getWidth() * 0.55);
                layoutParams.setMargins(0, 0, 0, 0);
                offView.setLayoutParams(layoutParams);
                MAX_MARGIN = sl.getWidth() - layoutParams.width;

            }
        });

        Drawable backgrounds[] = new Drawable[2];
        Resources res = getResources();
        backgrounds[0] = res.getDrawable(R.drawable.switch_button_off, null);
        backgrounds[1] = res.getDrawable(R.drawable.switch_button_on, null);

        crossfader = new TransitionDrawable(backgrounds);
        offView.setBackground(crossfader);
    }


    /**
     * Takes the maximum margin and pushes the layout to the right with the margin.
     * Changes the text appearance for each side
     */
    private void slideSwitchToTheRight() {
        offView.animate().translationX(MAX_MARGIN).setInterpolator(new FastOutSlowInInterpolator()).setDuration(300).start();
        crossfader.startTransition(300);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            negativeText.setTextAppearance(R.style.Afladagbok_Text_DarkBlue_LargerText_Regular);
            positiveText.setTextAppearance(R.style.Afladagbok_Text_White_LargerText_Bold);
        } else {
            negativeText.setTextAppearance(getContext(), R.style.Afladagbok_Text_DarkBlue_LargerText_Regular);
            positiveText.setTextAppearance(getContext(), R.style.Afladagbok_Text_White_LargerText_Bold);
        }
        negativeText.setTypeface(Typeface.DEFAULT);
        positiveText.setTypeface(Typeface.DEFAULT_BOLD);
    }

    /**
     * Removes the margin so it returns to the left side
     * Changes the text appearance for each side
     */
    private void slideSwitchToTheLeft() {
        offView.animate().translationX(0).setInterpolator(new FastOutSlowInInterpolator()).setDuration(300).start();
        crossfader.reverseTransition(300);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            negativeText.setTextAppearance(R.style.Afladagbok_Text_White_LargerText_Bold);
            positiveText.setTextAppearance(R.style.Afladagbok_Text_DarkBlue_LargerText_Regular);
        } else {
            negativeText.setTextAppearance(getContext(), R.style.Afladagbok_Text_White_LargerText_Bold);
            positiveText.setTextAppearance(getContext(), R.style.Afladagbok_Text_DarkBlue_LargerText_Regular);
        }
        negativeText.setTypeface(Typeface.DEFAULT_BOLD);
        positiveText.setTypeface(Typeface.DEFAULT);
    }

    public void setButtonText(String negativeString, String positiveString) {
        negativeText.setText(negativeString);
        positiveText.setText(positiveString);
    }
}
