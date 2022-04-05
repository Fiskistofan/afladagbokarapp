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

package is.stokkur.afladagbok.android.login.phone;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.constraintlayout.widget.ConstraintSet;
import androidx.lifecycle.ViewModelProviders;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.Editable;
import android.text.Html;
import android.text.Layout;
import android.text.TextWatcher;
import android.text.method.LinkMovementMethod;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.firebase.FirebaseException;
import com.google.firebase.FirebaseNetworkException;
import com.google.firebase.FirebaseTooManyRequestsException;


import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.PhoneAuthCredential;
import com.google.firebase.auth.PhoneAuthOptions;
import com.google.firebase.auth.PhoneAuthProvider;

import java.util.concurrent.TimeUnit;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.MainActivity;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.base.OnBackPressedListener;
import is.stokkur.afladagbok.android.utils.TemporaryData;

import static is.stokkur.afladagbok.android.utils.Utils.hideSoftKeyboard;

/**
 * Created by annalaufey on 11/23/17.
 */

public class PhoneFragment
        extends BaseFragment
        implements OnBackPressedListener {

    private static final String TAG = PhoneFragment.class.getSimpleName();

    public String mVerificationId = "";
    public String phoneNumber = "";
    public PhoneAuthProvider.ForceResendingToken mResendToken;
    @BindView(R.id.phone_number_input)
    EditText phoneNumberEdit;
    @BindView(R.id.login_description_txt)
    TextView loginDescription;
    @BindView(R.id.login_progressbar)
    ProgressBar progressBar;
    @BindView(R.id.login_button)
    RelativeLayout loginButton;
    @BindView(R.id.check_button_image)
    ImageView checkButtonImage;
    @BindView(R.id.ic_logo)
    ImageView main_logo;
    @BindView(R.id.title_text)
    TextView title_text;
    @BindView(R.id.resend_sms)
    Button resend_sms;
    @BindView(R.id.login_layout)
    ConstraintLayout loginBottomLayout;
    @BindView(R.id.root_layout)
    ConstraintLayout rootLayout;

    Rect visibleRect = new Rect();
    boolean keyboardActive = false;

    PhoneViewModel viewModel;
    private PhoneAuthProvider.OnVerificationStateChangedCallbacks mCallbacks;
    private FirebaseAuth mAuth;
    private boolean smsViewVisible = false;
    private View rootView;

    public static PhoneFragment newInstance() {
        PhoneFragment view = new PhoneFragment();
        return view;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.login_fragment, container, false);
        ButterKnife.bind(this, rootView);
        viewModel = ViewModelProviders.of(this).get(PhoneViewModel.class);
        viewModel.mView = this;
        viewModel.getError().observe(this, errorWrapper -> {
            hideProgressBar();
            if (errorWrapper != null && errorWrapper.getThrowable() != null) {
                displayError(errorWrapper.getThrowable().getMessage(), true);
            } else {
                displayError(getString(R.string.general_error), true);
            }
        });
        mAuth = FirebaseAuth.getInstance();
        mAuth.useAppLanguage();
        progressBar.setVisibility(View.INVISIBLE);
        ((BaseActivity) getActivity()).setOnBackPressedListener(this);
        initLoginButton();
        disableLoginButton();
        rootView.getWindowVisibleDisplayFrame(visibleRect);
        rootView.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v,
                                       int left,
                                       int top,
                                       int right,
                                       int bottom,
                                       int oldLeft,
                                       int oldTop,
                                       int oldRight,
                                       int oldBottom) {

                Rect r = new Rect();
                rootView.getWindowVisibleDisplayFrame(r);

                if(!keyboardActive && r.height() < visibleRect.height()){
                    onKeyboardShow();
                    keyboardActive = true;
                }
                if(keyboardActive && r.height() == visibleRect.height()){
                    onKeyboardHide();
                    keyboardActive = false;
                }

            }
        });

        this.showAppClosedAlert(getContext());
        return rootView;
    }

    private void initLoginButton() {
        phoneNumberEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (!smsViewVisible) {
                    if (phoneNumberEdit.getText().length() > 6) {
                        enableLoginButton();
                    } else {
                        disableLoginButton();
                    }
                } else {
                    if (phoneNumberEdit.getText().length() == 6) {
                        enableLoginButton();
                    } else {
                        disableLoginButton();
                    }
                }
            }
        });
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        // Checks whether a hardware keyboard is available
        if (newConfig.hardKeyboardHidden == Configuration.HARDKEYBOARDHIDDEN_NO || newConfig.keyboardHidden == Configuration.KEYBOARDHIDDEN_NO) {
            onKeyboardShow();
        } else if (newConfig.hardKeyboardHidden == Configuration.HARDKEYBOARDHIDDEN_YES || newConfig.keyboardHidden == Configuration.KEYBOARDHIDDEN_YES) {
            onKeyboardHide();
        }
    }

    @OnClick(R.id.login_button)
    public void loginButtonClicked() {
        showProgressBar();
        if (smsViewVisible) {
            sendSmsCode();
        } else {
            sendPhoneNumber();
        }
    }

    @OnClick(R.id.resend_sms)
    public void resendSMS(){
        PhoneAuthOptions.Builder phoneAuthOptsBuilder = PhoneAuthOptions.newBuilder();
        phoneAuthOptsBuilder.setPhoneNumber(phoneNumber);
        phoneAuthOptsBuilder.setTimeout(60L,TimeUnit.SECONDS);
        phoneAuthOptsBuilder.setActivity(getActivity());
        phoneAuthOptsBuilder.setCallbacks(mCallbacks);
        phoneAuthOptsBuilder.setForceResendingToken(mResendToken);
        PhoneAuthProvider.verifyPhoneNumber(phoneAuthOptsBuilder.build());
    }

    private void sendPhoneNumber() {

        hideSoftKeyboard(getActivity());
        phoneNumber = phoneNumberEdit.getText().toString().trim();
        if (phoneNumber.isEmpty()) {
            displayError(getString(R.string.insert_valid_phone_number_error), true);
            hideProgressBar();
            return;
        }
        if (!phoneNumber.startsWith("+")) {
            phoneNumber = "+354" + phoneNumber;
        }
        mCallbacks = new PhoneAuthProvider.OnVerificationStateChangedCallbacks() {

            @Override
            public void onVerificationCompleted(PhoneAuthCredential phoneAuthCredential) {
                Log.d(TAG, "onVerificationCompleted:" + phoneAuthCredential);
                TemporaryData.authCredential = phoneAuthCredential;
                signInWithPhoneAuthCredential(phoneAuthCredential);
                if (TemporaryData.authCredential.getSmsCode() != null) {
                    phoneNumberEdit.setText(TemporaryData.authCredential.getSmsCode());
                }
            }

            @Override
            public void onVerificationFailed(FirebaseException e) {
                Log.d(TAG, "onVerificationFailed", e);
                hideProgressBar();
                if (e instanceof FirebaseNetworkException) {
                    displayError(getString(R.string.no_internet_error), true);
                } else if (e instanceof FirebaseTooManyRequestsException) {
                    displayError(getString(R.string.too_many_requests), true);
                } else {
                    displayError(getString(R.string.insert_valid_phone_number_error), true);
                }
            }

            @Override
            public void onCodeSent(String verificationId, PhoneAuthProvider.ForceResendingToken token) {
                super.onCodeSent(verificationId, token);
                mVerificationId = verificationId;
                mResendToken = token;
                setSMSCodeView();
            }
        };

        PhoneAuthOptions.Builder phoneAuthOptsBuilder = PhoneAuthOptions.newBuilder();
        phoneAuthOptsBuilder.setPhoneNumber(phoneNumber);
        phoneAuthOptsBuilder.setTimeout(60L,TimeUnit.SECONDS);
        phoneAuthOptsBuilder.setActivity(getActivity());
        phoneAuthOptsBuilder.setCallbacks(mCallbacks);
        PhoneAuthProvider.verifyPhoneNumber(phoneAuthOptsBuilder.build());
        // endCallbacks
    }

    @Override
    public void onResume() {
        super.onResume();
        setUpContent();
    }

    private void sendSmsCode() {
        hideSoftKeyboard(getActivity());
        String smsCode = phoneNumberEdit.getText().toString().trim();
        if (smsCode.isEmpty()) {
            hideProgressBar();
            displayError(getString(R.string.insert_valid_sms_error), true);
        } else {
            PhoneAuthCredential mCredential = PhoneAuthProvider.getCredential(mVerificationId, smsCode);
            signInWithPhoneAuthCredential(mCredential);
        }
    }

    private void signInWithPhoneAuthCredential(PhoneAuthCredential credential) {
        hideSoftKeyboard(getActivity());
        mAuth.signInWithCredential(credential)
                .addOnCompleteListener(getActivity(), task -> {
                    if (task.isSuccessful()) {
                        Log.d(TAG, "signInWithCredential:success");
                        FirebaseUser user = task.getResult().getUser();
                        viewModel.getUserProfile();
                    } else {
                        Log.d(TAG, "signInWithCredential:failure", task.getException());
                        hideProgressBar();
                        if (task.getException() instanceof FirebaseNetworkException) {
                            displayError(getString(R.string.no_internet_error), true);
                        } else {
                            displayError(getString(R.string.insert_valid_sms_error), true);
                        }
                    }
                });
    }

    public void setSMSCodeView() {
        smsViewVisible = true;
        hideProgressBar();
        resend_sms.setVisibility(View.VISIBLE);
        loginDescription.setText(getString(R.string.sms_code_description, phoneNumber));
        phoneNumberEdit.setText("");
        phoneNumberEdit.setHint(getString(R.string.sms_code_hint));
        phoneNumberEdit.requestFocus();
    }

    public void setPhoneView() {
        smsViewVisible = false;
        hideProgressBar();
        resend_sms.setVisibility(View.GONE);
        loginDescription.setText(getString(R.string.login_description));
        phoneNumberEdit.setHint(getString(R.string.enter_phone_hint));
        phoneNumberEdit.setText("");
        phoneNumberEdit.requestFocus();


    }

    public void enableLoginButton() {
        loginButton.setBackground(getResources().getDrawable(R.drawable.green_save_button));
        checkButtonImage.setImageDrawable(getResources().getDrawable(R.drawable.ic_checked));
        loginButton.setClickable(true);
        loginButton.setEnabled(true);
    }

    public void disableLoginButton() {
        loginButton.setBackground(getResources().getDrawable(R.drawable.green_disabled_button));
        checkButtonImage.setImageDrawable(getResources().getDrawable(R.drawable.ic_checked_disabled));
        loginButton.setClickable(false);
        loginButton.setEnabled(false);
    }

    public void goToMainView() {
        Intent intent = new Intent(getActivity(), MainActivity.class);
        startActivity(intent);
        getActivity().finish();
    }

    @Override
    public void showProgressBar() {
        super.showProgressBar();
        progressBar.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideProgressBar() {
        super.hideProgressBar();
        progressBar.setVisibility(View.GONE);
    }

    @Override
    public boolean goBack() {
        if (smsViewVisible) {
            setPhoneView();
            return true;
        }
        return false;
    }

    void showAppClosedAlert(Context ctx){
        Dialog dialog = new Dialog(ctx);
        dialog.setContentView(R.layout.closure_layout);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(false);
        dialog.setCanceledOnTouchOutside(false);


        TextView linkView = (TextView) dialog.findViewById(R.id.content_link);
        linkView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String link = getResources().getString(R.string.eof_link_to_fis);
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(link));
                startActivity(browserIntent);
            }
        });



        dialog.findViewById(R.id.close_dialog).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    private void onKeyboardShow(){
        Log.e("KEYBOARD_EVENT","onShow");
        ViewGroup.LayoutParams lp =  loginBottomLayout.getLayoutParams();
        lp.height = (int) TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP,
                82,
                getResources().getDisplayMetrics()
        );
        loginBottomLayout.setLayoutParams(lp);

        if (smsViewVisible) {
            title_text.setVisibility(View.GONE);
            main_logo.setVisibility(View.GONE);
        } else {
            title_text.setVisibility(View.VISIBLE);
            main_logo.setVisibility(View.VISIBLE);
        }
        ConstraintSet constSet = new ConstraintSet();
        constSet.clone(rootLayout);
        constSet.connect(
                R.id.ic_logo, ConstraintSet.TOP,
                R.id.root_layout,ConstraintSet.TOP,
                (int) TypedValue.applyDimension(
                        TypedValue.COMPLEX_UNIT_DIP,
                        70,
                        getResources().getDisplayMetrics()
                )
        );
        constSet.applyTo(rootLayout);
    }

    private void onKeyboardHide(){
        Log.e("KEYBOARD_EVENT","onHide");
        ConstraintLayout.LayoutParams lp = (ConstraintLayout.LayoutParams) loginBottomLayout.getLayoutParams();
        lp.height = (int) TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP,
                122,
                getResources().getDisplayMetrics()
        );
        loginBottomLayout.setLayoutParams(lp);


        title_text.setVisibility(View.VISIBLE);
        main_logo.setVisibility(View.VISIBLE);


        ConstraintSet constSet = new ConstraintSet();
        constSet.clone(rootLayout);
        constSet.connect(
                R.id.ic_logo, ConstraintSet.TOP,
                R.id.root_layout,ConstraintSet.TOP,
                (int) TypedValue.applyDimension(
                        TypedValue.COMPLEX_UNIT_DIP,
                        178,
                        getResources().getDisplayMetrics()
                )
        );
        constSet.applyTo(rootLayout);
    }

    private void setUpContent(){
        Rect r = new Rect();
        rootView.getWindowVisibleDisplayFrame(r);

        if(!keyboardActive && r.height() < visibleRect.height()){
            onKeyboardShow();
            keyboardActive = true;
        }
        if(keyboardActive && r.height() == visibleRect.height()){
            onKeyboardHide();
            keyboardActive = false;
        }
    }

}
