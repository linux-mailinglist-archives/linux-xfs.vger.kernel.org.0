Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFD04303CA
	for <lists+linux-xfs@lfdr.de>; Sat, 16 Oct 2021 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbhJPQmK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 16 Oct 2021 12:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbhJPQmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Oct 2021 12:42:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3159C061570;
        Sat, 16 Oct 2021 09:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m+/01TelQmBNfXwVuV7nEanECorZjkMuzOgfdURTYOY=; b=RiRE9VN0tHQNnKKD3WDLCfF35k
        Phk7aInITfjVIkSQvFG5WBTWm/unqkCV22YezdmuSKtqozr/taMnHwqUjEZrPFjQvQmIHY9n6HGVI
        NJMhYQTIc3vVguttckPiHomY80SABnb6NivaD4idfe7Lj3NHeG9YJSolkKBoTnMPUZ9KwzGAZFr4k
        PcJC+TDuVe3RJntjG7APQ99AQ9QJqSUIsy9ti9jNNq8FXSYLd1t7m7RXtx2szXlSjC5bzq/h1x4ba
        AIShMuky2bDx3M2Ssjj7llkdqYvP09vclZm9aOaYV7ukLdOZ6rtx4tRemA7HXBJMlQgsVaBNdwrVu
        UpKiUVgw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbmiJ-009mGF-Tq; Sat, 16 Oct 2021 16:39:22 +0000
Date:   Sat, 16 Oct 2021 17:39:15 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        Linux MM <linux-mm@kvack.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, Christoph Hellwig <hch@lst.de>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v1 2/2] mm: remove extra ZONE_DEVICE struct page refcount
Message-ID: <YWsAM3isdPSv2S3E@casper.infradead.org>
References: <20211014153928.16805-1-alex.sierra@amd.com>
 <20211014153928.16805-3-alex.sierra@amd.com>
 <20211014170634.GV2744544@nvidia.com>
 <YWh6PL7nvh4DqXCI@casper.infradead.org>
 <CAPcyv4hBdSwdtG6Hnx9mDsRXiPMyhNH=4hDuv8JZ+U+Jj4RUWg@mail.gmail.com>
 <20211014230606.GZ2744544@nvidia.com>
 <CAPcyv4hC4qxbO46hp=XBpDaVbeh=qdY6TgvacXRprQ55Qwe-Dg@mail.gmail.com>
 <20211016154450.GJ2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211016154450.GJ2744544@nvidia.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 16, 2021 at 12:44:50PM -0300, Jason Gunthorpe wrote:
> Assuming changing FSDAX is hard.. How would DAX people feel about just
> deleting the PUD/PMD support until it can be done with compound pages?

I think there are customers who would find that an unacceptable answer :-)
