Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0498C1E9DC
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 10:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEOIKR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 04:10:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEOIKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 04:10:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Llw202V+pyJNau999vteAhxMA/I9OrOw9lnjwmoJT/I=; b=mq737vqQ3i4Hf1DQ2AHKhNG2w
        ODoMbLV0rWo30FZkzjmUBmnEWFM9VnP2ttPRHY3SgubKffSj2nuJE6qTtJA/ppuy7zqa8Mg26628L
        NFI4bGuT4zGk7ANkWwxJiSlbLTkCpNVBzaK0in++9ipkVPBHTTZgMm7S9u45aQTGmKtFcsKH4rTBY
        qho8cA8mR6OnVh+7w9lVwJ1RYVfNWbYe1MtVYBYihtX0F7QPN9TXZRSm7fV/cpG+zz0pXeBawTCoC
        J9/Zu89PB8r58oQq/3HvhNcClelKY0rTovHnk5YZyAprmUqb+nBV97DIzulhXm739LNRAru7u27+F
        dGY71ez8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQozQ-0004rY-Un; Wed, 15 May 2019 08:10:16 +0000
Date:   Wed, 15 May 2019 01:10:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190515081016.GJ29211@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
 <20190510173413.GD18992@infradead.org>
 <20190513154610.GF61135@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513154610.GF61135@bfoster>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> WRT to merging the functions, I'm a little concerned about the result
> being too large. What do you think about folding in _vextent_type() but
> at the same time factoring out the rmap/counter/resv post alloc bits
> into an xfs_alloc_ag_vextent_accounting() helper or some such?

Sounds good to me.  I've looked at the function and another nice thing
to do would be to not pass the ret bno to xfs_alloc_ag_vextent_agfl,
but let that function fill out the args structure return value itself.

Also for the trace piints that still say near in them - maybe we should
change that near to ag?
