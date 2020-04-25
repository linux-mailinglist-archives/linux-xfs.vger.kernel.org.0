Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6766D1B8811
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Apr 2020 19:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDYRVX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 25 Apr 2020 13:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:21:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A727DC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ON+SOfd5XTOA/761DGAjmy99xF
        EE6B5k2wmMAlBRMnLxaPQS6LzMiNefII8BWmYqdHxChe+vzZ3lfDKBS/uAJ+M5mtkuwwuoufeXUHV
        WEr1yDIhplZTqOKO3CnEmOku0GjlZTUXhJ81LOrFbD3AeurqGKDKYrJFRT6zE1Cq96rqFl2rCjlPd
        2vckAxG58jPI9z5w0714FWt7oHu0qEeqqdRT2zuSBXEjJ/AdeqJLTuz0yUIuP9jzl3heFPBtXK2/b
        vVNZeWgOut6VbwF5IYv+7VYkmoz4+B2BGwvOwn+LBcZDZYPctCmvXQgr+MSNbiyNgzL5/2uVgoejf
        A6RjJT/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOUV-00027u-7Z; Sat, 25 Apr 2020 17:21:23 +0000
Date:   Sat, 25 Apr 2020 10:21:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 01/13] xfs: refactor failed buffer resubmission into
 xfsaild
Message-ID: <20200425172123.GA30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
