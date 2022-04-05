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

package is.stokkur.afladagbok.android.terms;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.annotation.NonNull;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;

import com.google.firebase.auth.FirebaseAuth;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.extensions.ActivityExtensions;
import is.stokkur.afladagbok.android.utils.Persistence;

public class AcceptTermsDialog
        extends Dialog
        implements View.OnClickListener {

    private static final String PRIVACY_TERMS_RESPONSE_KEY = "privacy_terms_response";

    private PrivacyTermsResponse mResponse;

    public AcceptTermsDialog(@NonNull Context context,
                             PrivacyTermsResponse response) {
        super(context);
        mResponse = response;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (savedInstanceState != null) {
            mResponse = savedInstanceState.getParcelable(PRIVACY_TERMS_RESPONSE_KEY);
        }
        if (mResponse == null) {
            dismiss();
            return;
        }

        setCancelable(false);
        setCanceledOnTouchOutside(false);

        Window window = getWindow();
        setContentView(R.layout.dialog_terms);
        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(0));
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT);
        }
        this.<Button>findViewById(R.id.dialog_terms_action_read_more).setOnClickListener(this);
        this.<Button>findViewById(R.id.dialog_terms_action_accept).setOnClickListener(this);
    }

    @NonNull
    @Override
    public Bundle onSaveInstanceState() {
        Bundle bundle = super.onSaveInstanceState();
        bundle.putParcelable(PRIVACY_TERMS_RESPONSE_KEY, mResponse);
        return bundle;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.dialog_terms_action_read_more: {
                openPrivacyLink();
                break;
            }

            case R.id.dialog_terms_action_accept: {
                acceptTerms();
                break;
            }
        }
    }

    private void openPrivacyLink() {
        final Context context = getContext();
        final Resources resources = context.getResources();
        ActivityExtensions.openWebLink(context, mResponse.mTerms.mContent,
                () -> ActivityExtensions.showInfoDialog(context,
                        resources.getString(R.string.app_name),
                        resources.getString(R.string.privacy_policy_failed_to_open),
                        resources.getString(android.R.string.ok)));
    }

    @SuppressLint("CheckResult")
    @SuppressWarnings("ResultOfMethodCallIgnored")
    private void acceptTerms() {
        dismiss();
        if (Persistence.getStringValue(Persistence.KEY_PROFILE) != null &&
                FirebaseAuth.getInstance().getCurrentUser() != null) {
            Client.sharedClient().getClientInterface()
                    .acceptTerms(mResponse.mTerms.mId)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(r -> { /* Empty */ }, t -> { /* Empty */ });
        }
    }

}
