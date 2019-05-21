Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9302324A7A
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 10:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfEUId5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 04:33:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfEUId5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qm+8ue1U0X9iH0PqLyR36LY6xp/BrF0gANl9z6PNr/M=; b=dosClT/9WWUEL19hUeqkJWgnS
        qLw2eAz1Tyy0P1jy3YZ3XzutLmgJZY3ZrCClxJ6if3kxNmpY2yvOgSJOjmGfM0jaomNhEZM8Cuns+
        SJi1IHAg4I46cu7fsh1tR/UfT/cAKzhAtH9odSvRzt4NX8ugMT4hv96ymUxofJnbc8l1aC/8f04/4
        H2CRUcfOB+3x4dBHlSTjBEIXzz1bZ5HHU3iq90xfADECvzlyoXcYZf3c7EjfZy8gnKZ/fNl5HY6fj
        AFIeynO5hNRezb2wZF3l8NbU1pWzpNnWHvOHyN/4WyRWJFikZwy4ucLZ85hZzrrLU5rKyIzBmaM/P
        3m+fchEag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT0Dc-0000sT-LH; Tue, 21 May 2019 08:33:56 +0000
Date:   Tue, 21 May 2019 01:33:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] libxfs: factor common xfs_trans_bjoin code
Message-ID: <20190521083356.GC533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-4-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410427-1837-4-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks just as good in userspace as it did in the kernel :)
