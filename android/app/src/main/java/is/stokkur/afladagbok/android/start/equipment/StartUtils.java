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

package is.stokkur.afladagbok.android.start.equipment;

import android.app.Activity;
import androidx.annotation.IdRes;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;

import static is.stokkur.afladagbok.android.utils.Utils.showSoftKeyboard;

class StartUtils {

    static void throwIfZeroOrLess(EditText editText)
            throws Exception {
        if (Double.parseDouble(editText.getText().toString().trim()) <= 0) {
            throw new Exception();
        }
    }

    static EditText setupInputLayout(Activity activity,
                                     View parent,
                                     @IdRes int layoutId,
                                     @IdRes int inputId,
                                     TextWatcher watcher,
                                     String inputDefault) {
        View layout = parent.findViewById(layoutId);
        final EditText input = layout.findViewById(inputId);
        input.setText(inputDefault);
        layout.setOnClickListener(v -> {
            input.requestFocus();
            showSoftKeyboard(activity, input);
            input.setSelection(input.getText().length());
        });
        input.setOnFocusChangeListener((v, hasFocus) -> {
            if (hasFocus) {
                input.setSelection(input.getText().length());
            }
        });
        input.addTextChangedListener(watcher);
        return input;
    }

}
