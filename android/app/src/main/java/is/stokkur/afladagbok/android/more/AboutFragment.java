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

import android.app.Activity;
import android.content.res.Resources;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import is.stokkur.afladagbok.android.BuildConfig;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.extensions.ActivityExtensions;

/**
 * Created by annalaufey on 11/22/17.
 */

public class AboutFragment extends BaseFragment {

    public static AboutFragment newInstance() {
        return new AboutFragment();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.about_fragment, container, false);
    }

    @Override
    public void onViewCreated(View view,
                              @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        view.findViewById(R.id.about_app_privacy_policy).setOnClickListener(v -> openPrivacyPolicyLink());
        String version = "v" + BuildConfig.VERSION_NAME + " - " + BuildConfig.VERSION_CODE;
        view.<TextView>findViewById(R.id.about_app_version).setText(version);
    }

    private void openPrivacyPolicyLink() {
        final Activity activity = getActivity();
        final Resources resources = activity.getResources();
        ActivityExtensions.openWebLink(activity, resources.getString(R.string.privacy_policy_url),
                () -> ActivityExtensions.showInfoDialog(activity,
                        resources.getString(R.string.app_name),
                        resources.getString(R.string.privacy_policy_failed_to_open),
                        resources.getString(android.R.string.ok)));
    }

}
