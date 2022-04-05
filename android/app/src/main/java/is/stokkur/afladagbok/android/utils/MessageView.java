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
import android.os.Handler;
import android.os.Looper;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;

/**
 * Created by annalaufey on 2/14/18.
 */

public class MessageView extends RelativeLayout {

    private final Context context;
    private final Handler mHandler = new Handler(Looper.getMainLooper());

    public MessageView(Context context) {
        super(context);
        this.context = context;
        init();
    }

    public MessageView(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        init();
    }

    public MessageView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.context = context;
        init();
    }

    public MessageView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        this.context = context;
        init();
    }

    private void init() {
        inflate(getContext(), R.layout.message_view, this);
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
    }

    public void displayError(String message, boolean isError) {
        mHandler.removeCallbacksAndMessages(null);
        LinearLayout messageLayout = (LinearLayout) findViewById(R.id.message_layout);
        TextView messageText = (TextView) findViewById(R.id.message_text);
        messageText.setText(message);
        ImageView messageIcon = (ImageView) findViewById(R.id.message_icon);
        TextView messageClose = (TextView) findViewById(R.id.message_close);
        messageClose.setOnClickListener(v -> hideError());
        messageLayout.setVisibility(View.VISIBLE);
        Animation slide = AnimationUtils.loadAnimation(context, R.anim.slide_down);
        if (isError) {
            messageLayout.setBackground(getResources().getDrawable(R.drawable.error_view_background));
            messageIcon.setImageDrawable(null);
            messageIcon.setVisibility(View.GONE);
            ViewGroup.LayoutParams vglp = messageLayout.getLayoutParams();
            RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) vglp;
            int sideMargin = (int) TypedValue.applyDimension(
                    TypedValue.COMPLEX_UNIT_DIP,
                    20,
                    getResources().getDisplayMetrics()
            );
            int topMargin = (int) TypedValue.applyDimension(
                    TypedValue.COMPLEX_UNIT_DIP,
                    80,
                    getResources().getDisplayMetrics()
            );
            lp.setMargins(
                    sideMargin,
                    topMargin,
                    sideMargin,
                    0
            );
            //messageLayout.setLayoutParams(lp);
            //((BaseActivity) context).getWindow().setStatusBarColor(getResources().getColor(R.color.dark_red));
        } else {
            messageLayout.setBackground(getResources().getDrawable(R.drawable.message_view_background));
            messageIcon.setImageDrawable(getResources().getDrawable(R.drawable.ic_thumbsup));
            messageIcon.setVisibility(View.VISIBLE);
            ViewGroup.LayoutParams vglp = messageLayout.getLayoutParams();
            RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) vglp;
            lp.setMargins(0, 0, 0, 0);
            ((BaseActivity) context).getWindow().setStatusBarColor(getResources().getColor(R.color.green));
        }

        messageLayout.startAnimation(slide);
        mHandler.postDelayed(this::hideError, 5000L);
    }

    public void hideError() {
        mHandler.removeCallbacksAndMessages(null);
        LinearLayout messageLayout = (LinearLayout) findViewById(R.id.message_layout);
        Animation slide = AnimationUtils.loadAnimation(context, R.anim.slide_up);
        slide.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                messageLayout.setVisibility(GONE);
                ((BaseActivity) context).getWindow().setStatusBarColor(getResources().getColor(R.color.header_blue));
                ((BaseActivity) context).animationStopped();
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        messageLayout.startAnimation(slide);
    }

}
