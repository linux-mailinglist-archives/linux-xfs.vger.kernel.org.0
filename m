Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6942124A85
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfEUIgz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 04:36:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfEUIgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=trV2szqUF3pEZrVGbcRewZzP7
        NpEuQI3iWAn9HCjZu5yoTBV3UjyP/z6mXTX9ia+JdFy4KIEEAapZirIxMlBzo2ydCX1RmV89mWRa0
        Cu7bkiMbMiUxl6lqx9klF+Y68erbXytA3/xK6MbFMtZpOtIYm3NragkRTo4kids3RixzbA7Non81L
        WrFrLElQUJ3YDvhIB1ZfiUyjs3PZYn5fcH6OQHKXVfPh+zlG1m7o+MyCxJGEQ2o8GOOI7ehJ4hBA4
        2Ecn7KqOw4UGxGvMiwUTv0pdT0/deIsAbiZYNMQD/w8yar9pO/hYVFaPNV/BLjzeRQFU5+HG+rlir
        X5LFLDgIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT0GU-00037n-IT; Tue, 21 May 2019 08:36:54 +0000
Date:   Tue, 21 May 2019 01:36:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] libxfs: create current_time helper and sync
 xfs_trans_ichgtime
Message-ID: <20190521083654.GF533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-7-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410427-1837-7-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
