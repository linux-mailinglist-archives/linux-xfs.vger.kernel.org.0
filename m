Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D1C24A86
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 10:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfEUIhe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 04:37:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfEUIhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:37:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=LpIFO+CK+XHTVG/4OarKNwJ3V
        JI1jOp3DmeCeZWfvDX6NesXEyFfwESMWzW8BnweRAMPBIBD9aiGgIWthbNeWgGjK8u8Th6JG0m33r
        mqMqpgezlIxIR4xhTFAN83kDPYA6W1RjVp42Yhh33WPCMo8f0Jp+0pL79kd75RwVflxkN10Kv8zdm
        d+S6uk/9/YDyfBIO/ArR8FudHZ/9YEp/pjBSHV7wCP6w1tibW5NDDi3Y92/QSwKHQs3pLEo+60lxW
        fuG0XTry0vUuPH/sM4lYxzXtqCBfDtyEyuvFrSlt3DsOeINC4YZGXPpL1/H6PQWvGmzDhQ68RZdfE
        B2vwY3mhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT0H6-0003HS-8s; Tue, 21 May 2019 08:37:32 +0000
Date:   Tue, 21 May 2019 01:37:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7 V2] libxfs: share kernel's xfs_trans_inode.c
Message-ID: <20190521083732.GG533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-8-git-send-email-sandeen@redhat.com>
 <79484f9f-42e3-29bc-9d84-897e0191ede2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79484f9f-42e3-29bc-9d84-897e0191ede2@sandeen.net>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
