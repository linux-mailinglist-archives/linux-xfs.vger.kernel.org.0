Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE124A84
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 10:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfEUIgh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 04:36:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58212 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfEUIgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:36:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Zuj5nD0beqQBAgWy56Kh7Cw/sEgcsVkpt8nbhWH2Rng=; b=OIhtzSEHjo5i12hM3TLDl2PQh
        V7KEerkRnWqyP8efVIraQBYUnVSfubeencpUqkEDf98JQ7TY7FgAIz9zK6dUR1WFYplejtU5r0RKQ
        TCJkYBb0hw45ALf8Bcsx+vx89AxfVPoBZuBZEklz1ZZWdvaKz1flZ2udAWkKm+Ds9DkbPnuYGaGFF
        xoktLrXqzvYuex2G8mhfEB1JJcdq0sdnIBvJWZA1D+N9j8FM51+vmYthnd6v1QmWcfs0PMz4IQy0o
        HxCowzKn8T0Cf/pJq3oFbw5KFWrJnMAuiguhAgfgP7jGJH0svOfFl+2XGH13455RmTLfEJVlYyOzH
        AWq2suLyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT0GC-00035x-LP; Tue, 21 May 2019 08:36:36 +0000
Date:   Tue, 21 May 2019 01:36:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: factor log item initialisation
Message-ID: <20190521083636.GE533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-6-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410427-1837-6-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good.
