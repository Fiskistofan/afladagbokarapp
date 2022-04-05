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

package is.stokkur.afladagbok.android.onboarding;

import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.utils.Persistence;

public class OnboardingActivity extends AppCompatActivity {
    private enum OnboardingStep {
        STEP_1, STEP_2, STEP_3, STEP_4, STEP_5
    }

    @BindView(R.id.onboarding_phone)
    ImageView onboardingPhoneImage;
    @BindView(R.id.onboarding_content)
    TextView onboardingContent;

    private OnboardingStep currentStep = OnboardingStep.STEP_1;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_onboarding);
        ButterKnife.bind(this);
        onboardingPhoneImage.setBackgroundResource(0);
        onboardingPhoneImage.setImageDrawable(getDrawable(R.drawable.onboarding_phone_1));
    }

    @OnClick(R.id.skip_button)
    public void skipOnboarding(){
        finishOnboarding();
    }

    @OnClick(R.id.next_step_button)
    public void nextStep(){
        switch (currentStep) {
            case STEP_1:
                currentStep = OnboardingStep.STEP_2;
                onboardingPhoneImage.setBackgroundResource(0);
                onboardingPhoneImage.setImageDrawable(getDrawable(R.drawable.onboarding_phone_2));
                onboardingContent.setText(R.string.onboarding_content_2);
                break;
            case STEP_2:
                currentStep = OnboardingStep.STEP_3;
                onboardingPhoneImage.setBackgroundResource(0);
                onboardingPhoneImage.setImageDrawable(getDrawable(R.drawable.onboarding_phone_3));
                onboardingContent.setText(R.string.onboarding_content_3);
                break;
            case STEP_3:
                currentStep = OnboardingStep.STEP_4;
                onboardingPhoneImage.setBackgroundResource(0);
                onboardingPhoneImage.setImageDrawable(getDrawable(R.drawable.onboarding_phone_4));
                onboardingContent.setText(R.string.onboarding_content_4);
                break;
            case STEP_4:
                currentStep = OnboardingStep.STEP_5;
                onboardingPhoneImage.setBackgroundResource(0);
                onboardingPhoneImage.setImageDrawable(getDrawable(R.drawable.onboarding_phone_5));
                onboardingContent.setText(R.string.onboarding_content_5);
                break;
            case STEP_5:
                finishOnboarding();
                break;
        }
    }

    private void finishOnboarding(){
        // Set persistence flag
        Persistence.saveBooleanValue(Persistence.KEY_ONBOARDING_FLAG,true);
        finish();
    }
}
