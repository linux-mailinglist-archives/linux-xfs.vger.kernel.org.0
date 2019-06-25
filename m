Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01512551B6
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfFYOaG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 10:30:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46930 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfFYOaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 10:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=SU/3szEzP3yh7s1zEHyiB+OOv
        Nhu7fclcBRJG7A6++gLLXeiYiZS+kFlwNmKaXWGldib9IUgCkPJpVrKVAE+H5+Avtb7ezBlvQQNIG
        v7Gxo31whmvxyYS3WuS1PZOJLMCjkSiIicvZGxAKEh5VXcAJ1je1Dq4pGtK9rg6xVnPmFj/XY+vMn
        nvNDLa6Pkhl3bu9zPdYJgnlTroO/ZHx3HV097HfhQz1oKo3tjHUTw2YmCMcVfnpEBXaEUhP4WMwY7
        LWd7CRGbSsjFPpPi80D0zCPnUHznwUl0L0hX2k64Plpplhxh34rztOhEf5CrTQdH8aPtkBoa4GFPd
        ikiTaTd0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfmSS-0004ab-KG; Tue, 25 Jun 2019 14:30:04 +0000
Date:   Tue, 25 Jun 2019 07:30:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] xfs_info: limit findmnt to find mounted xfs filesystems
Message-ID: <20190625143004.GC11059@infradead.org>
References: <20190617095447.3748-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617095447.3748-1-amir73il@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
