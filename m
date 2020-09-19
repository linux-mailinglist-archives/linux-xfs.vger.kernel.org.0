Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652BD270AC7
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Sep 2020 07:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgISFNl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 19 Sep 2020 01:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFNk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 01:13:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDD6C0613CE;
        Fri, 18 Sep 2020 22:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oX9V/zdc0/wftNUBNvFf78AaGcTGWHXdzFBqFqi0LU0=; b=qkiLIXUFJ1demzQLLAysI4RnLq
        dUs4NnhHjPZQ80aJfwt0Yiz1JVl2Q15PBFD7/xPc6/NOveCrXG4cxx21x/uMDjFLbSGQFBSmq+2Zd
        I6JhOJNSsdOukZmqz3/H8zGUQRKu6QH1M+1o2MIuRf0fES0qDE+3tQrq3GmZ+7rvsMpgHW6qNzVsX
        FOVWJeKoeVVODptFIci1HU7qGAkYyIEKyzU97cdFgDVv7AM2TE18gsacNgROKPqsg0WM45tjeVPIj
        fcz78c5EDqpO9IG6g2YKPE/+nlnbpcP8FU8zjrsIzkvAHhxSPVXu67XvnTy5WS5GVmYRcH3tq/MRn
        CHCeBWyg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVBq-000823-Ly; Sat, 19 Sep 2020 05:13:38 +0000
Date:   Sat, 19 Sep 2020 06:13:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 27/24] common/rc: fix indentation in _scratch_mkfs_sized
Message-ID: <20200919051338.GB30063@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <20200918021109.GL7954@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918021109.GL7954@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:11:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix the weird indentation in _scratch_mkfs_sized.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
