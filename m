Return-Path: <linux-xfs+bounces-10610-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA74392FDEE
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2024 17:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 400B51F22DB2
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2024 15:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD9B174EE7;
	Fri, 12 Jul 2024 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmgWxvM6"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F85916EB6A
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720799557; cv=none; b=rzlE4LbZnKw7Zw6cSmBFq94/KagKkL7y4oA/N46Wqu7h9modkpGLIaTg3qB5EVB0A7n7dZWZ2kq31hBg/FWuSd7k1+GJCD3WgeTgkYCLZLX9f30zVmLGCry7fzpOTvoHhEYtl2UJ+pyj68+9KvqiMM3n/wZUNP/OdJoQ6/2XoOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720799557; c=relaxed/simple;
	bh=ZnYtEwQmRhSInSuZM5bGERSfZOhYNMj6nDH2d7KOFRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2NzCglidZ28dQEXjKAhkGN9QCN7K+T9PjX9y6M+6eQbr/SMALn7jksR7MxJvQBhY27idrn6SG2kwWO76U4jB0UntrD7ieDHqbfcsR9RPc/YDD6cKJcEmyKrGD+mZiUUs/eKTu/Tnqel6iCC0vA4O0izihvQyThYK7gNKyBKXvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmgWxvM6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720799554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CBPZJXhtPTYw9uGWwBpC8EVMxJRjwQ/Iz+iND+SW6sA=;
	b=PmgWxvM6EAtMenNTAoVwv7W1mM4igF78kfNKy8xvpx2q7dWoVO4rxrJMgEE1CNP8gMpLdx
	fxJL1qPAA1I9W9VMMFNivK/+6SxnrDYuLCmyI1Q4pnPF5K1gyayTcAIbvYbP+F2uRlIs/l
	feDCZyHcGPHXqBMK3qGG6XtnElhqilc=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-l9oiEKUdN2y8--RdMWnUyg-1; Fri, 12 Jul 2024 11:52:32 -0400
X-MC-Unique: l9oiEKUdN2y8--RdMWnUyg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3d62ad9f453so22264b6e.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 08:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720799552; x=1721404352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CBPZJXhtPTYw9uGWwBpC8EVMxJRjwQ/Iz+iND+SW6sA=;
        b=g0HDNoIUJ8ih81xEKVUJ7ijyeuOUogWc7qXM1/7EJ1fQhNfeBY4/oFi2Zk1eQqDxE6
         lL5dN+6b/d8ZZxb+YqWMCn0ngVTgdiVQfPbL6dcjr+IvPzLrQ1bYbIPF1iuNB8MOwHyf
         J6PnmiGiEkqBX7YI9xTTnpswfVPMR2LXCVjlQJbOacGklENp9/X/0+Wk4V/PVBMUYP4T
         bpzVkEZi7TkYYnnzHfMJ3gjDinpEEZNejXajp3l1hNjnMl/MsH49kUB4vKwRyqymQPk4
         +i1e4mCWKTvFw+dxqy7yBM7L2kspNqX90Gz0pqRzNz/LWsJkoWq1CJuC6Cip6P+pBE02
         wWwA==
X-Forwarded-Encrypted: i=1; AJvYcCV85EFd1vU5tfJznITIhT9MTWqzKiB8Vfh1Vgq9Tql1Snxg/MRjdb+19u27K56RHjcvcy5/tpPlMbHrSDgZMuD+QjKsmVYVSN/U
X-Gm-Message-State: AOJu0YyYFoBqlDVnmUgheKwH6sgaai1mMQqgROqSVERU/Wju0l/8Jkwx
	2eAiMYX1VpjhywwoDiuM5jC0KiQchuHMNCcsTTCBbeSWnVFwPK210walwEQ/CsbTUGRtzXHGKR2
	iKOQki+crdsXaaf5MyEtxl7Z/Ufr0+C2OqkhyEykwk757Dwgvdm3u+1+bbw==
X-Received: by 2002:a05:6808:18a4:b0:3d9:3f72:7147 with SMTP id 5614622812f47-3daa0cc727emr5077550b6e.3.1720799551954;
        Fri, 12 Jul 2024 08:52:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/ZIrWNSDLGpdOzmVtr7gg5txILa2tK9NGlD5tHXAm+7q1klaoYYw+zZj//kgznCBpBAfzHQ==
X-Received: by 2002:a05:6808:18a4:b0:3d9:3f72:7147 with SMTP id 5614622812f47-3daa0cc727emr5077526b6e.3.1720799551507;
        Fri, 12 Jul 2024 08:52:31 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f19012fa9sm414621985a.46.2024.07.12.08.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 08:52:31 -0700 (PDT)
Date: Fri, 12 Jul 2024 11:52:27 -0400
From: Peter Xu <peterx@redhat.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
	jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
	will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	david@fromorbit.com, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 11/13] huge_memory: Remove dead vmf_insert_pXd code
Message-ID: <ZpFROxbDINDc43m_@x1n>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com>
 <400a4584f6f628998a7093aee49d9f86c592754b.1719386613.git-series.apopple@nvidia.com>
 <ZogCDpfSyCcjVXWH@x1n>
 <87zfqrw69i.fsf@nvdebian.thelocal>
 <Zo1dqTPLn_gosrSO@x1n>
 <87sewf48s6.fsf@nvdebian.thelocal>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87sewf48s6.fsf@nvdebian.thelocal>

On Fri, Jul 12, 2024 at 12:40:39PM +1000, Alistair Popple wrote:
> 
> Peter Xu <peterx@redhat.com> writes:
> 
> > On Tue, Jul 09, 2024 at 02:07:31PM +1000, Alistair Popple wrote:
> >> 
> >> Peter Xu <peterx@redhat.com> writes:
> >> 
> >> > Hi, Alistair,
> >> >
> >> > On Thu, Jun 27, 2024 at 10:54:26AM +1000, Alistair Popple wrote:
> >> >> Now that DAX is managing page reference counts the same as normal
> >> >> pages there are no callers for vmf_insert_pXd functions so remove
> >> >> them.
> >> >> 
> >> >> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> >> >> ---
> >> >>  include/linux/huge_mm.h |   2 +-
> >> >>  mm/huge_memory.c        | 165 +-----------------------------------------
> >> >>  2 files changed, 167 deletions(-)
> >> >> 
> >> >> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >> >> index 9207d8e..0fb6bff 100644
> >> >> --- a/include/linux/huge_mm.h
> >> >> +++ b/include/linux/huge_mm.h
> >> >> @@ -37,8 +37,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >> >>  		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
> >> >>  		    unsigned long cp_flags);
> >> >>  
> >> >> -vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
> >> >> -vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
> >> >>  vm_fault_t dax_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
> >> >>  vm_fault_t dax_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
> >> >
> >> > There's a plan to support huge pfnmaps in VFIO, which may still make good
> >> > use of these functions.  I think it's fine to remove them but it may mean
> >> > we'll need to add them back when supporting pfnmaps with no memmap.
> >> 
> >> I'm ok with that. If we need them back in future it shouldn't be too
> >> hard to add them back again. I just couldn't find any callers of them
> >> once DAX stopped using them and the usual policy is to remove unused
> >> functions.
> >
> > True.  Currently the pmd/pud helpers are only used in dax.
> >
> >> 
> >> > Is it still possible to make the old API generic to both service the new
> >> > dax refcount plan, but at the meantime working for pfn injections when
> >> > there's no page struct?
> >> 
> >> I don't think so - this new dax refcount plan relies on having a struct
> >> page to take references on so I don't think it makes much sense to
> >> combine it with something that doesn't have a struct page. It sounds
> >> like the situation is the analogue of vm_insert_page()
> >> vs. vmf_insert_pfn() - it's possible for both to exist but there's not
> >> really anything that can be shared between the two APIs as one has a
> >> page and the other is just a raw PFN.
> >
> > I still think most of the codes should be shared on e.g. most of sanity
> > checks, pgtable injections, pgtable deposits (for pmd) and so on.
> 
> Yeah, it was mostly the BUG_ON's that weren't applicable once pXd_devmap
> went away.
> 
> > To be explicit, I wonder whether something like below diff would be
> > applicable on top of the patch "huge_memory: Allow mappings of PMD sized
> > pages" in this series, which introduced dax_insert_pfn_pmd() for dax:
> >
> > $ diff origin new
> > 1c1
> > < vm_fault_t dax_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
> > ---
> >> vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
> > 55,58c55,60
> > <       folio = page_folio(page);
> > <       folio_get(folio);
> > <       folio_add_file_rmap_pmd(folio, page, vma);
> > <       add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
> > ---
> >>         if (page) {
> >>                 folio = page_folio(page);
> >>                 folio_get(folio);
> >>                 folio_add_file_rmap_pmd(folio, page, vma);
> >>                 add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
> >>         }
> 
> We get the page from calling pfn_t_to_page(pfn). This is safe for the
> DAX case but is it safe to use a page returned by this more generally?

Good question.  I thought it should work when the caller doesn't set any
bit in PFN_FLAGS_MASK, but it turns out it's not the case?  As I just
notice:

static inline bool pfn_t_has_page(pfn_t pfn)
{
	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
}

So it looks like "no PFN_FLAGS" case should also fall into this category of
"(pfn.val & PFN_DEV) == 0"..

I'm not sure whether my understanding is correct, though.  Maybe we'd want
to double check with pfn_valid() when it's a generic function.

> 
> From an API perspective it would make more sense for the DAX code to
> pass the page rather than the pfn. I didn't do that because device DAX
> just had the PFN and this was DAX-specific code. But if we want to make
> it generic I'd rather have callers pass the page in.
> 
> Of course that probably doesn't help you, because then the call would be
> vmf_insert_page_pmd() rather than a raw pfn, but as you point out there
> might be some common code we could share.

It'll be fine if it needs page*, then it'll be NULL for VFIO.

So far it looks cleaner if it has the pgtable entry anyway to me, as that
indeed contains the pfn.  But I'd trust you more on what should it look
like, as I didn't read the whole series here.

> 
> >
> > As most of the rest look very similar to what pfn injections would need..
> > and in the PoC of ours we're using vmf_insert_pfn_pmd/pud().
> 
> Do you have the PoC posted anywhere so I can get an understanding of how
> this might be used?

https://github.com/xzpeter/linux/commits/vfio-pfnmap-all/

Specifically Alex's commit here:

https://github.com/xzpeter/linux/commit/afd05f1082bc78738e280f1fc1937da52b2572ed

Just a note that it's still work in progress.  Alex did run it through (not
this tree, but an older one) and it works pretty well so far.

I think it's because so far nothing involves the pfn flags, the only one
has it involved is (taking pmd as example):

insert_pfn_pmd():
	if (!pmd_none(*pmd)) {
		if (write) {
			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
				goto out_unlock;
			}
			entry = pmd_mkyoung(*pmd);
			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
				update_mmu_cache_pmd(vma, addr, pmd);
		}

		goto out_unlock;
	}

But for VFIO it'll definitely be pmd_none() here, so the whole path ignores
pfn flags so far here, I assume.

> 
> > That also reminds me on whether it'll be easier to implement the new dax
> > support for page struct on top of vmf_insert_pfn_pmd/pud, rather than
> > removing the 1st then adding the new one.  Maybe it'll reduce code churns,
> > and would that also make reviews easier?
> 
> Yeah, that's a good observation. I think it was just a quirk of how I
> was developing this and also not caring about the PFN case so I'll see
> what that looks like.

Great!  I hope it'll reduce the diff for this series too, so it could be a
win-win.

Thanks,

-- 
Peter Xu


