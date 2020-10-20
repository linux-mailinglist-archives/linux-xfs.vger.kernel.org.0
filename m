Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0F28304D
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Oct 2020 08:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgJEGPz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Oct 2020 02:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgJEGPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 02:15:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BC3C0613CE
        for <linux-xfs@vger.kernel.org>; Sun,  4 Oct 2020 23:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S2wxAjtcjS/fl1xvDzNC10ljuFzIX5sQyByzbF5P8Mg=; b=kDvjigQzsno/uq30Jb6kBokfrl
        0xvLW4UDKEE5JePhrhdkNZyksXfm2IM++cidghdedKZTlFO7yQPznOBhiWnW56ENeixHnLpkRYkGQ
        VGMTIs6MyNWncDnBkZr/7WziK4gFqkzzt5sNPqmQTx/TbbGa6fyiPHOm2O7ZnY0K5rZiO2qkO/Y6q
        LBWGzpso0XHreUgCCu3Da+UbcP409cXFLqAQlv5hOMeC1/XN2MkKXdSbIyjIb42DsR4gYhtHnTVjC
        T/IpBgIupQgn/PvJQPZZ59en3QzifON08YzAqSLTzpN1r7aSMdMJti4Nz0iiIPvjP2aG7qSAV9mOl
        rYsrE8dw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPJmm-0000bI-0D; Mon, 05 Oct 2020 06:15:48 +0000
Date:   Mon, 5 Oct 2020 07:15:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs_repair: coordinate parallel updates to the rt
 bitmap
Message-ID: <20201005061547.GA1856@infradead.org>
References: <20201002201831.GA49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002201831.GA49547@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 01:18:31PM -0700, Darrick J. Wong wrote:
> +			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups);

This adds a 81 char line.

Except fo that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
