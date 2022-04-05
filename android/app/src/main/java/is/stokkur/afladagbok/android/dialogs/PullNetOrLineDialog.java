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

import android.app.Activity;
import android.app.Dialog;
import android.graphics.drawable.ColorDrawable;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.FishingEquipments;

import static is.stokkur.afladagbok.android.utils.Utils.getIconForType;
import static is.stokkur.afladagbok.android.utils.Utils.getTossType;
import static is.stokkur.afladagbok.android.utils.Utils.showSoftKeyboard;

public class PullNetOrLineDialog extends Dialog {

    public <T extends Fragment & PullNetOrLineRegistrable> PullNetOrLineDialog(final @NonNull T fragment, final StoredToss toss) {
        super(fragment.getActivity());
        Window window = getWindow();
        setContentView(R.layout.pull_net_line_dialog);
        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(0));
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT);
            window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE);
        }

        final Activity activity = fragment.getActivity();

        String type = getTossType(toss);

        int iconId = getIconForType(type);
        ((ImageView) findViewById(R.id.pull_in_toss_type_icon)).
                setImageResource(iconId);

        String typePullMessage;
        if (type.compareTo(FishingEquipments.NET) == 0) {
            typePullMessage = activity.getString(R.string.pull_how_many_net);
        } else if (type.compareTo(FishingEquipments.HAND) == 0) {
            typePullMessage = activity.getString(R.string.pull_how_many_hand);
        } else {
            typePullMessage = activity.getString(R.string.pull_how_many_line);
        }
        ((TextView) findViewById(R.id.amount_pull_in_label)).setText(typePullMessage);

        final int available = toss.getCount() - toss.getPulledCount();
        ((TextView) findViewById(R.id.amount_of_equipment)).setText(activity.
                getString(R.string.of_amount, available));

        final EditText amountToPullIn = findViewById(R.id.amount_edit_pull_in_txt);
        amountToPullIn.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                String amount = amountToPullIn.getText().toString().trim();
                try {
                    int intAmount = Integer.parseInt(amount);
                    if (intAmount > 0 && intAmount <= available) {
                        dismiss();
                        fragment.registerNetPullIn(toss, amount);
                    }
                } catch (Exception ex) {
                    // Empty
                }
                return true;
            }
            return false;
        });

        showSoftKeyboard(activity, amountToPullIn);
    }

}
