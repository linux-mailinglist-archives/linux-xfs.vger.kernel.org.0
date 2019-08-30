Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12559A2EDC
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 07:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfH3FYG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 01:24:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46812 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbfH3FYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oB17fCv1wa+4ia+hhFytN+bGz/D9v5LZMmX6Lc/WURo=; b=j/jVeVn0aUpjd2SKD2spcFEhR
        GeJ2aHmtndM8uG0KrzneH0f8MdfwJWnG4jKUlUnRTeLXUf6yLB9hONTDks0XF3k7yL2quPZxUMin6
        mWzACObuzGOZkKoIpx/02QBLmIWP1pU1DFI5Z3RuwKhog+LmG5RSYxFpod9taZ3Zhnuz4Xab1KK6s
        b53ZnC5jWAnN7s1jfacWzjXLGQOtuouSPpSlNAmBrnMlJqdZ5DgFoYK/s5I3dEedThlCbbBvnXcRN
        Bu3RDlXkYGN1DVa2e8XheyNC8bd7OPFBNnyh0JXjiTkQu0R896pouHu+jKrCP0npXldqhqV+iYrsm
        SAnbdR3kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ZOI-0001xn-4Z; Fri, 30 Aug 2019 05:24:06 +0000
Date:   Thu, 29 Aug 2019 22:24:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190830052406.GB6077@infradead.org>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-5-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:47:09PM +1000, Dave Chinner wrote:
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

This still has the upper-case O in Signed-Off-By..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
