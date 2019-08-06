Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F1B8382F
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Aug 2019 19:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfHFRqm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Aug 2019 13:46:42 -0400
Received: from ms.lwn.net ([45.79.88.28]:45188 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728836AbfHFRqm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Aug 2019 13:46:42 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 42E452C0;
        Tue,  6 Aug 2019 17:46:41 +0000 (UTC)
Date:   Tue, 6 Aug 2019 11:46:40 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: fs: Convert
 xfs-delayed-logging-design.txt to ReSt
Message-ID: <20190806114640.7eeb3f13@lwn.net>
In-Reply-To: <20190806090323.GA16095@localhost>
References: <20190806090323.GA16095@localhost>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 6 Aug 2019 10:03:23 +0100
Sheriff Esseson <sheriffesseson@gmail.com> wrote:

> Convert xfs-delayed-logging-design.txt to ReST and fix broken references.
> The enumerations at "Lifecycle Changes" breaks because of lines begining with
> "<", treat as diagrams.

[...]

> @@ -27,14 +30,18 @@ written to disk after change D, we would see in the log the following series
>  of transactions, their contents and the log sequence number (LSN) of the
>  transaction:
>  
> +        ============           =========        ==============
>  	Transaction		Contents	LSN
> +        ============           =========        ==============
>  	   A			   A		   X
>  	   B			  A+B		  X+n
>  	   C			 A+B+C		 X+n+m
>  	   D			A+B+C+D		X+n+m+o
>  	    <object written to disk>
> -	   E			   E		   Y (> X+n+m+o)
> +        ------------------------------------------------------
> +	   E			   E		Y (> X+n+m+o)
>  	   F			  E+F		  Y+p
> +        ============           =========        ==============

So this is really more of a diagram than a table; I'd suggest just using a
literal block like you did elsewhere.

[...]

>  Lifecycle Changes
> +=================
>  
> -The existing log item life cycle is as follows:
> +The existing log item life cycle is as follows::
>  
>  	1. Transaction allocate
>  	2. Transaction reserve

This, instead, is a proper outline.  I guess the literal block is OK, but
it feels like we could do better.

Thanks,

jon
