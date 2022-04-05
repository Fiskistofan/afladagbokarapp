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

package is.stokkur.afladagbok.android.book;

import android.content.Context;
import android.content.res.Resources;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredPull;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.utils.Utils;


/**
 * Created by annalaufey on 11/15/17.
 */

public class TripPullsAdapter
        extends RecyclerView.Adapter<TripPullsAdapter.TripPullsViewHolder> {

    final private Context mContext;
    final private LayoutInflater mInflater;
    final private BookPullsFragment mFragment;
    final private ArrayList<CheckableStoredPull> mStoredPulls = new ArrayList<>();

    private boolean mMultiSelection = false;

    TripPullsAdapter(Context context,
                     BookPullsFragment fragment) {
        mContext = context;
        mFragment = fragment;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public TripPullsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new TripPullsViewHolder(mInflater.inflate(R.layout.laid_out_item, parent, false));
    }

    @Override
    public void onBindViewHolder(TripPullsViewHolder holder, int position) {
        holder.bindTo(mStoredPulls.get(position));
    }

    @Override
    public int getItemCount() {
        return mStoredPulls.size();
    }

    void replacePulls(List<CheckableStoredPull> pulls) {
        mStoredPulls.clear();
        mStoredPulls.addAll(pulls);
        toggleMultiSelection(mMultiSelection);
    }

    int getSelectedCount() {
        int selected = 0;
        if (mMultiSelection) {
            int itemCount = getItemCount();
            for (int i = 0; i < itemCount; ++i) {
                if (mStoredPulls.get(i).getChecked()) {
                    selected += mStoredPulls.get(i).getCount();
                }
            }
        }
        return selected;
    }

    boolean multiSelectionEnabled() {
        return mMultiSelection;
    }

    void toggleAction(){
        if (getSelectedCount() > 0){
            clearSelection();
        } else {
            selectAll();
        }
    }

    void clearSelection(){
        int itemCount = getItemCount();
        for (int i = 0; i < itemCount; ++i) {
            mStoredPulls.get(i).setChecked(false);
        }
        notifyDataSetChanged();
    }

    void selectAll(){
        int itemCount = getItemCount();
        for (int i = 0; i < itemCount; ++i) {
            mStoredPulls.get(i).setChecked(true);
        }
        notifyDataSetChanged();
    }

    void toggleMultiSelection(boolean enable) {
        mMultiSelection = enable;
        int itemCount = getItemCount();
        for (int i = 0; i < itemCount; ++i) {
            mStoredPulls.get(i).setChecked(enable);
        }
        notifyDataSetChanged();
    }

    List<StoredPull> getSelectedItems() {
        int itemCount = getItemCount();
        CheckableStoredPull checkableStoredPull;
        ArrayList<StoredPull> pulls = new ArrayList<>();
        for (int i = 0; i < itemCount; ++i) {
            checkableStoredPull = mStoredPulls.get(i);
            if (checkableStoredPull.getChecked()) {
                pulls.add(checkableStoredPull);
            }
        }
        return pulls;
    }

    public class TripPullsViewHolder
            extends RecyclerView.ViewHolder
            implements View.OnClickListener, CompoundButton.OnCheckedChangeListener {

        @BindView(R.id.registered_time)
        TextView registeredTime;

        @BindView(R.id.registered_type_icon)
        ImageView mTypeIcon;

        @BindView(R.id.registered_caret)
        ImageView mCaretIcon;

        private final TextView mLastRegisteredInfo;
        private final CheckBox mCheckBox;
        private CheckableStoredPull mPull;

        TripPullsViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
            mLastRegisteredInfo = itemView.findViewById(R.id.last_registered_info);
            mCheckBox = itemView.findViewById(R.id.registered_checkbox);
            mCheckBox.setOnCheckedChangeListener(this);
            itemView.setOnClickListener(this);
        }

        void bindTo(CheckableStoredPull pull) {
            mPull = pull;
            Resources resources = mContext.getResources();

            mTypeIcon.setImageResource(Utils.getIconForType(pull.getEquipmentTypeId()));
            registeredTime.setText(resources.getString(R.string.pull_hour, pull.getId()));

            mFragment.viewModel.getStoredToss(pull.getTossId()).observe(mFragment,storedToss -> {
                String tossCount = pull.getCount() + "/" + storedToss.getCount();
                mFragment.viewModel.pullHaveCatchesRegistered(pull.getPullId()).observe(mFragment,hasCatches -> {
                    String storedMsg = hasCatches ?
                            resources.getString(R.string.pulls_registered) :
                            resources.getString(R.string.no_pulls_registered);
                    mLastRegisteredInfo.setText(resources.getString(R.string.pull_info,tossCount+" - "+storedMsg));
                });
            });

            if (mMultiSelection) {
                mCaretIcon.setVisibility(View.INVISIBLE);
                mCheckBox.setVisibility(View.VISIBLE);
                mCheckBox.setChecked(pull.getChecked());
            } else {
                mCaretIcon.setVisibility(View.VISIBLE);
                mCheckBox.setVisibility(View.INVISIBLE);
                mCheckBox.setChecked(false);
            }
        }

        @Override
        public void onClick(View v) {
            if (mMultiSelection) {
                mCheckBox.toggle();
            } else {
                mFragment.goToNextFragment(mPull);
            }
        }

        @Override
        public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
            mPull.setChecked(isChecked);
            mFragment.updateMultiButtonState();
        }

    }

}
