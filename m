Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E981613E0
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgBQNrS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:47:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgBQNrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:47:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZJHDgvtgzd0+C3coWxobfyfHEBTvaIFffxpARb4vIKM=; b=IawqyrG5mgodh/m9JIPH7pcfWR
        71aNeoMKbC2FZJmoIC9KMbzPElVGkGW/nQf8ITeEsrPxMGSnaYmq1Ym3texHIXu+4fmixfTnsbu75
        nXikmJW2vOwu8wJTsNMnLNaqKCOKuXsg6cgOJPSob+DQi2HAo/kN1DMNuw5itzfe13IlPKIHKN4qF
        oLAX3yqJjF8Y6oyd/VDxPPI6Np9xkyz3wwKAD4Ulq0BovEn+QDvbevxA8NeDvISQItj3pd/vdW2Cz
        efbm4KDmba4LQ71fvYWEuakbWxAw3W2oSVbHcRWze0R1ALaBORF9r6XH1PJXxEDbTHVnLTiqFcpJ4
        GHohy2NQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gk1-0007Pd-Js; Mon, 17 Feb 2020 13:47:17 +0000
Date:   Mon, 17 Feb 2020 05:47:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: refactor attr root block pointer check
Message-ID: <20200217134717.GC18371@infradead.org>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086358798.2079557.6562544272527988911.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086358798.2079557.6562544272527988911.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In process_longform_attr, replace the agcount check with a call to the
> fsblock verification function in libxfs.  Now we can also catch blocks
> that point to static FS metadata.

Looks good (especially with the fixup from Eric):

Reviewed-by: Christoph Hellwig <hch@lst.de>
