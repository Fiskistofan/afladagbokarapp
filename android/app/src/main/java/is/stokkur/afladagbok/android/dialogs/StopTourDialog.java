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

package is.stokkur.afladagbok.android.dialogs;

import android.app.Dialog;
import android.graphics.drawable.ColorDrawable;
import android.view.ViewGroup;
import android.view.Window;

import androidx.fragment.app.Fragment;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.utils.Utils;

public class StopTourDialog extends Dialog {

    public <T extends Fragment & StopTourListener> StopTourDialog(final T fragment) {
        super(fragment.getActivity());
        Window window = getWindow();
        setContentView(R.layout.stop_tour_dialog);
        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(0));
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT);
        }

        findViewById(R.id.stop_tour_dialog_button).setOnClickListener(v -> {
            dismiss();
            if (!Utils.isNetworkAvailable()) {
                fragment.displayError(fragment.getString(R.string.no_internet_error), true);
            } else {
                fragment.stopTourConfirmed();
            }
        });
        findViewById(R.id.cancel_dialog_button).setOnClickListener(v -> dismiss());
    }

}
