Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2E42DF53
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Oct 2021 18:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhJNQoD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Oct 2021 12:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbhJNQn7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 12:43:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A34C061570;
        Thu, 14 Oct 2021 09:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fxcLVRG2Jku0ajx1R51YzWOEmjfFWOgHA52RS+phND0=; b=hJChu81HMFnOk2mOnqyhd+aZtv
        3RzV8zPkoJkUHzUTz5GgiZ+listhRDQekfOBkR90UtQ2T1RzDS9xEDu+Xg8X6MpGuaPXdTpJENrP+
        N9lL4PeVE+DrKuffpedBb6bGoElR+WBOPDTHCqD/0FdDaj2E3SOaJdIB8LZ0jOe1/lg1Wx2fVq29b
        /pGZtjz7ji+oGbkLPezf8ivP5RJ20y0B2SqhEYs3dFDfEWnNSUQoHSWexPFklVi1xKgZUBUzD4jvp
        Z0D9PwJQldNvfJyOvWouJg6sE1rfP4OM+KHdUwffPvVoYHqOKxa84aqjmiMUJprcaZXS2lBIKYutb
        cHcfxkiA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mb3mJ-008SzI-UQ; Thu, 14 Oct 2021 16:40:35 +0000
Date:   Thu, 14 Oct 2021 17:40:23 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com, apopple@nvidia.com
Subject: Re: [PATCH v1 1/2] ext4/xfs: add page refcount helper
Message-ID: <YWhdd7IFspw0wicW@casper.infradead.org>
References: <20211014153928.16805-1-alex.sierra@amd.com>
 <20211014153928.16805-2-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014153928.16805-2-alex.sierra@amd.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 10:39:27AM -0500, Alex Sierra wrote:
> From: Ralph Campbell <rcampbell@nvidia.com>
> 
> There are several places where ZONE_DEVICE struct pages assume a reference
> count == 1 means the page is idle and free. Instead of open coding this,
> add a helper function to hide this detail.
> 
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Theodore Ts'o <tytso@mit.edu>
> Acked-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
