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

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.ViewGroup;
import android.view.Window;

import java.util.List;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredToss;

public class SelectTossDialog extends Dialog {

    public SelectTossDialog(Fragment fragment,
                            List<StoredToss> storedTossArrayList,
                            final TossSelectedListener listener) {
        super(fragment.getActivity());
        Window window = getWindow();
        setContentView(R.layout.toss_list_dialog);
        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(0));
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT);
        }

        final Activity activity = fragment.getActivity();

        findViewById(R.id.toss_list_close).setOnClickListener(v -> dismiss());

        RecyclerView recyclerView = findViewById(R.id.list_view);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(activity);
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.addItemDecoration(
                new DividerItemDecoration(activity, DividerItemDecoration.VERTICAL));
        SelectTossDialogAdapter adapter =
                new SelectTossDialogAdapter(storedTossArrayList, activity);
        adapter.setTossSelectedListener(storedToss -> {
            dismiss();
            listener.tossSelected(storedToss);
        });
        adapter.notifyDataSetChanged();
        recyclerView.setAdapter(adapter);
    }

}
