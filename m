Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231AFF3981
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 21:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbfKGU3o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 15:29:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725823AbfKGU3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 15:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573158582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dBLDnViySKdLik0O4Q6w1Nfndk1AGn/fm7boLOIDXmo=;
        b=iSFS97m5n8Oj7ESebui7vYoSgQjqBjhpXnyY+tt4tFc3z2VDPl3DeHUKodwyZUlo8lKSwg
        q2HXVvWhE9lyhsvCS4mcshLHo6E0J+31sdPZgMNjERfZs4JmHHPhRbRusmiqWVG/OI+2yL
        fGtTSzS4DbOjB6L1LMAiGgAjpmRbVL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-gDbhqPWXNeC802pzl7_M2w-1; Thu, 07 Nov 2019 15:29:41 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F8B58017E0;
        Thu,  7 Nov 2019 20:29:40 +0000 (UTC)
Received: from redhat.com (ovpn-123-234.rdu2.redhat.com [10.10.123.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9D345C578;
        Thu,  7 Nov 2019 20:29:36 +0000 (UTC)
Date:   Thu, 7 Nov 2019 14:29:35 -0600
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] xfs_io: fix memory leak in add_enckey
Message-ID: <20191107202935.GA609511@redhat.com>
References: <4eb1073f-91fb-a4bc-aae8-d54dc5a6b8aa@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4eb1073f-91fb-a4bc-aae8-d54dc5a6b8aa@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: gDbhqPWXNeC802pzl7_M2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 10:50:59AM -0600, Eric Sandeen wrote:
> Invalid arguments to add_enckey will leak the "arg" allocation,
> so fix that.
>=20
> Fixes: ba71de04 ("xfs_io/encrypt: add 'add_enckey' command")
> Fixes-coverity-id: 1454644
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>=20
> diff --git a/io/encrypt.c b/io/encrypt.c
> index 17d61cfb..c6a4e190 100644
> --- a/io/encrypt.c
> +++ b/io/encrypt.c
> @@ -696,6 +696,7 @@ add_enckey_f(int argc, char **argv)
>  =09=09=09=09goto out;
>  =09=09=09break;
>  =09=09default:
> +=09=09=09free(arg);
>  =09=09=09return command_usage(&add_enckey_cmd);
>  =09=09}
>  =09}
>=20

