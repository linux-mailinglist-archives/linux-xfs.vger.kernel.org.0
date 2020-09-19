Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A93270B17
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Sep 2020 08:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgISG2C (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 19 Sep 2020 02:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgISG2C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 02:28:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA3CC0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 23:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qEv84X9D7MpDeu86+xtPvvnRYnS2vwyzNgdpTbDz6+c=; b=TwPvZ25AnAyKrBl9Aqz0BQRzjO
        BLNOnQAqElOvlWtOAdbVGYzIwvBwlxXSPMrf2WXZlXOLNaYnWv5vKUe4DBCEvjjymeJgPoZkU7o3T
        9MwmfAfzm+A1Gxgu3ieSbm44oxIW2jS15ycPSCMP2ezF57YB8wSXnMO9vX7sg6eA0bLIlnRKIKUR3
        3zPz/M9xcVPxMWR0yhe8QJ+CtIQCdFwyYU+ypQS1ygEj8dJ7y4/mC92W1bJ/W8r9zA7uIUHGuLcTQ
        1UzgYYlMbCOxH4GxWKgOseHixiNtiHCqeKx1MU+yIo8zDL0GC2IPaiLl/15jXzJfSojDwFyBkY7HO
        /UEl85ow==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJWLe-0003eD-HE; Sat, 19 Sep 2020 06:27:50 +0000
Date:   Sat, 19 Sep 2020 07:27:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 5/7] xfs: remove the redundant crc feature check in
 xfs_attr3_rmt_verify
Message-ID: <20200919062750.GB13501@infradead.org>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-6-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600342728-21149-6-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:38:46PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We already check whether the crc feature is enabled before calling
> xfs_attr3_rmt_verify(), so remove the redundant feature check in that
> function.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
