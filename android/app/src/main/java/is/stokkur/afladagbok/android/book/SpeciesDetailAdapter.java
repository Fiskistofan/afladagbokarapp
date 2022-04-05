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
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.Species;
import is.stokkur.afladagbok.android.utils.SpeciesID;

/**
 * Created by annalaufey on 11/16/17.
 */

public class SpeciesDetailAdapter
        extends RecyclerView.Adapter<SpeciesDetailAdapter.SpeciesDetailViewHolder>
        implements Filterable {

    private final ArrayList<Species> mSpecies = new ArrayList<>();
    private final ArrayList<Species> mFilteredSpecies = new ArrayList<>();
    private final Context context;
    private final LayoutInflater mInflater;
    private final SpeciesSelectedListener selectedListener;
    private final int speciesId;

    private final Filter mFilter = new Filter() {
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String query = constraint != null ? constraint.toString().toLowerCase() : "";
            ArrayList<Species> filter = new ArrayList<>();

            if (query.isEmpty()) {
                filter.addAll(mSpecies);
            } else {
                Species species;
                int size = mSpecies.size();
                for (int i = 0; i < size; ++i) {
                    species = mSpecies.get(i);
                    if (species.getSpeciesName().toLowerCase().contains(query)) {
                        filter.add(species);
                    }
                }
            }

            FilterResults results = new FilterResults();
            results.values = filter;
            results.count = filter.size();
            return results;
        }

        @Override
        protected void publishResults(CharSequence constraint,
                                      FilterResults results) {
            mFilteredSpecies.clear();
            //noinspection unchecked
            mFilteredSpecies.addAll((ArrayList<Species>) results.values);
            notifyDataSetChanged();
        }
    };

    public SpeciesDetailAdapter(List<Species> species,
                                Context context,
                                int speciesId,
                                SpeciesSelectedListener selectedListener) {
        mSpecies.addAll(species);
        mFilteredSpecies.addAll(species);
        this.context = context;
        mInflater = LayoutInflater.from(context);
        this.speciesId = speciesId;
        this.selectedListener = selectedListener;
    }

    @Override
    public SpeciesDetailViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new SpeciesDetailViewHolder(mInflater.inflate(R.layout.species_detail_item, parent, false));
    }

    @Override
    public void onBindViewHolder(SpeciesDetailViewHolder holder, int position) {
        Species species = mFilteredSpecies.get(position);
        holder.speciesName.setText(species.getSpeciesName());
        holder.selectedSpecies.setOnClickListener(v -> selectedListener.SelectSpecies(species));
        switch (speciesId) {
            case SpeciesID.FISH:
                holder.speciesIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fish));
                break;
            case SpeciesID.OTHER:
                holder.speciesIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_mammal_small));
                break;
            default:
                holder.speciesIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fish));
                break;
        }
    }

    @Override
    public int getItemCount() {
        return mFilteredSpecies.size();
    }

    @Override
    public Filter getFilter() {
        return mFilter;
    }

    class SpeciesDetailViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.species_detail_name)
        TextView speciesName;
        @BindView(R.id.species_detail_image)
        ImageView speciesIcon;
        @BindView(R.id.selected_species_layout)
        RelativeLayout selectedSpecies;

        SpeciesDetailViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);

        }
    }

}
