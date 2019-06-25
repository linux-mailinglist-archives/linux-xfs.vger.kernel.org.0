Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111CB54CD4
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfFYKz0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:55:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50261 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727578AbfFYKz0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:55:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 66B2C22114;
        Tue, 25 Jun 2019 06:55:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 25 Jun 2019 06:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        txdeIKHXVnX90szOluXyQJB5dst0UX0YsTrE3cY+PiQ=; b=BB4agAwSxYgY75Nl
        rNc/20U9JtP3LJuVBvF+jvjCLamyysB97IFfzpjfqit8HpuJjQl/Q8+jgyeTmJbk
        cXE6CQ6jU8EewzhjhIVt6k4O56LW9IERCFerrgNhyLviDgkJP8+pXEW8LDNJ+Bjb
        vSkedvuytRm5zEhYOar/dYJ6T9JMd/94spl9HOFcR4lDn9wAurAytgwiBTKuwYVP
        NkQ/lDY/yI7lKCruv1ef3eIr79MRYtJHJYgaH3fltjEnGM7EeGnSyEjmaVZFghUg
        K4nVIsNEyf0z8n2cBcmI5HgFrZQO0Tt5Gr5jJnvaESwT7Ai/6nL5EBkR7Xy8li0v
        /WO1sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=txdeIKHXVnX90szOluXyQJB5dst0UX0YsTrE3cY+P
        iQ=; b=H71UXQKrKkWORouAPoG+8QbFHg8ygm3WmrUbxCdZMQL6Up2Hs6iVBre8E
        /FM/xAR8ZG3oBvzrfm56WXgk+Z9H6oYpkj/kCLQtAQkt+/Xnf8Ml4EsqwuEKmMqB
        FFN58bhB1MJXUXHdNCuW05zSifMsqAd3N+xW5796AcmBCERXPUA1S9L0dwOCmIia
        pYcuMJW3x28MnJK6P88+nhHnRLp/vZdIS6Kmf0/3XlAgGhqZapEVl/RXHov8pwFY
        kKLdu8Jp1BUEbZ2Rc6VI6KsvEfW6a0F5pXTvkOT9ZaDdjI61+QMgUzYjOo6pfY6r
        ITNgtCTFRLTktyRuUHk7VW0IVN+hA==
X-ME-Sender: <xms:nP0RXVEfQT7KFPqIE39COdj_Y00_kgyANcQRtp3_mewtisYo07l9GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeggdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujeefrdehfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nP0RXekQrsFixNabfngAla1hOOKm_ixxkJ75C03RvtafUSCpcmsmVw>
    <xmx:nP0RXSJ2xUCiQKp0G8naYiWTo8oKePwCr99pA85UgDX66Nb_-i8JNw>
    <xmx:nP0RXfbhjG6LZbJDmGTRX6b42vgtl355foGg3D9NOzcPdVs9RaJoqA>
    <xmx:nf0RXR2KZbZi2HlUlNYaS3GOD9joIySDLT-WLb52LEvONSLuorYL2g>
Received: from pluto.themaw.net (unknown [118.208.173.53])
        by mail.messagingengine.com (Postfix) with ESMTPA id 830E8380075;
        Tue, 25 Jun 2019 06:55:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by pluto.themaw.net (Postfix) with ESMTP id 9AE501C0114;
        Tue, 25 Jun 2019 18:55:20 +0800 (AWST)
Message-ID: <ed9c2214830b70e33ed54772fa1652cd9c4910e3.camel@themaw.net>
Subject: Re: [PATCH 01/10] xfs: mount-api - add fs parameter description
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue, 25 Jun 2019 18:55:20 +0800
In-Reply-To: <20190625103445.GA30156@infradead.org>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <20190625103445.GA30156@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-06-25 at 03:34 -0700, Christoph Hellwig wrote:
> This is missing a cover letter to explain the point of this
> series.
> 
> It adds giant amount of code for not user visible benefit.  Why would
> we want this series?

A fair comment.

I'll add a cover letter when I post a v2 of the series.

Ian

