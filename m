Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1B51F25
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 01:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfFXXeu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 19:34:50 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37083 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbfFXXeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:34:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id EDC7E22453;
        Mon, 24 Jun 2019 19:34:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Jun 2019 19:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        fS1IoIZPZsOqFcYrbalz0pY+rIY/ELxvn84lTH6XoNE=; b=QEOpHXxjfNJiqNJa
        PfyBlllQITSWn8Gvt9SpA/fQmzPdl95yGym15xH0Quh1qAWeNRlPiq6v/BO6bpUO
        SqaKCp0Yady4KFPaKdwZWT1MUhPPWw3LZtkVVLNa+rFfqAPwKYQ34NgSqFeJbfoC
        jPLCfayCPrdE3AWiAauDCttxNZC7ZB/QqCYMOHHniQI/HzdiNEL/9Ug3d6rbJrhb
        skUPw8GRnB3lUAJ18Tl1j2HXryGltt+AYpcfiH9TEbL2DOwNjDwYf8aTohC+WgPv
        DGL3gVj4NczhTspExOw0hXh4/HKHhieRwGWJJZWtPBrio9Ky/Z3ErgA3hLxxquOf
        JsWXpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=fS1IoIZPZsOqFcYrbalz0pY+rIY/ELxvn84lTH6Xo
        NE=; b=IogERABhbwHSyiSPwroNoFkzV0j3QpnvVOOi6TpN6dfZ3STAw72sLZ2Jv
        mRpYdJsHAnO1qCkrkW2qOE1biMtVIjyKa2L3C0FBFdWM0LnZVjYyS3qCkuDCuP8H
        qycCIbojiOV5pnH9MZ2XljrRsfDvg6deUxphXVm0yjoRybGMydKJgCi+9l4Uvs/L
        kUnBD1p0dUxoEtaGAVgeLSFjivlF95RSRxPt+C0eBXL72rKqHOApjhI5Abei30ck
        fuI2dTPhCs1+iO8MqT+e8WAaexbMwDsDAKYURtGaquSFB7bN1x0Eb8zO3pC++l7d
        uo1qUj8J+HT0tiDD9Eg3GebCVmO9g==
X-ME-Sender: <xms:Fl4RXUrxnA6Z98A7Q0-A_xM0S5S0XCwoWUfIDKbeI6XNWsn53c0eFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujeefrdehfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Fl4RXVhCpkOeZ8dIv76gTakQS69BNZ0hlacRwewPp02828ZDJzlsGA>
    <xmx:Fl4RXRAQtAkVgkw9jSjbzNltwIxHkY8uUGP-XMuOOde-1r7wG9maAA>
    <xmx:Fl4RXaFEwwTb4dK6kpiDWMU_rGMdRfY6Qfh4HwFeJiRgeDdKk7uOtQ>
    <xmx:Fl4RXUoYxJYCuoaZABW-YIKOMQZZNjjIJVpBdFfpeFUFf36wYtwUrA>
Received: from pluto.themaw.net (unknown [118.208.173.53])
        by mail.messagingengine.com (Postfix) with ESMTPA id CFF14380075;
        Mon, 24 Jun 2019 19:34:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by pluto.themaw.net (Postfix) with ESMTP id 0C91F1C0110;
        Tue, 25 Jun 2019 07:34:42 +0800 (AWST)
Message-ID: <cca5319857aefccadb64dbcf084185fa8ecf6296.camel@themaw.net>
Subject: Re: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Tue, 25 Jun 2019 07:34:41 +0800
In-Reply-To: <20190624230633.GB5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134510851.2519.2387740442257250106.stgit@fedora-28>
         <20190624172943.GV5387@magnolia>
         <20190624223554.GA7777@dread.disaster.area>
         <20190624230633.GB5387@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-06-24 at 16:06 -0700, Darrick J. Wong wrote:
> On Tue, Jun 25, 2019 at 08:35:54AM +1000, Dave Chinner wrote:
> > On Mon, Jun 24, 2019 at 10:29:43AM -0700, Darrick J. Wong wrote:
> > > On Mon, Jun 24, 2019 at 10:58:30AM +0800, Ian Kent wrote:
> > > > The mount-api doesn't have a "human unit" parse type yet so
> > > > the options that have values like "10k" etc. still need to
> > > > be converted by the fs.
> > > 
> > > /me wonders if that ought to be lifted to fs_parser.c, or is xfs the
> > > only filesystem that has mount options with unit suffixes?
> > 
> > I've suggested the same thing (I've seen this patchset before :)
> > and ISTR it makes everything easier if we just keep it here for this
> > patchset and then lift it once everything is merged...
> 
> Ok, fair enough. :)

I mentioned it to David after Dave said much the same thing, David said
he had done some work on it but I haven't heard more yet.

> 
> --D
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com

